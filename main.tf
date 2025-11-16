#create a vpc
resource "aws_vpc" "custom_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "custom_terraform_vpc"
  }
}
#create a subnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.custom_vpc.id
  availability_zone = var.availability_zone
  cidr_block = var.subnet_cidr
  tags = {
    Name = "public_subnet"
  }
}
#create an internet gateway
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    Name = "terraform_igw"
  }
}
#create a route table
resource "aws_route_table" "public_RT" {
  vpc_id = aws_vpc.custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
}
#create a route table association
resource "aws_route_table_association" "public_RT_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_RT.id
}
#create a security group
resource "aws_security_group" "ec2_sg" {
  name        = "ec2_security_group"
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = aws_vpc.custom_vpc.id
  dynamic "ingress" {
    for_each = var.internal_port
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "terraform_security_group"
  }
}
#create key pair
resource "aws_key_pair" "terrafrom_key" {
  key_name   = var.key_name
  public_key = file("~/.ssh/terraform-key.pub")
}
#create an elastic IP
resource "aws_eip" "eip" {
  instance = aws_instance.jenkins_server.id
  domain   = "vpc"
  depends_on = [ aws_instance.jenkins_server, aws_internet_gateway.IGW ]
  tags = {
    Name = "Jenkins_EIP"
  }
}
#create an EC2 instance
resource "aws_instance" "jenkins_server" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  availability_zone = var.availability_zone
  key_name               = aws_key_pair.terrafrom_key.key_name
  user_data = file("${path.module}/install_jenkins.sh")
  root_block_device {
    encrypted = true
  }
    depends_on = [
    aws_internet_gateway.IGW,
    aws_route_table.public_RT
  ]
  tags = {
    Name = "Jenkins_Server"
  }
}