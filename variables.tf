variable "region" {
  description = "The AWS region to create resources in"
  type        = string
  default     = "us-east-1"
}
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}
variable "subnet_cidr" {
  description = "The CIDR block for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}
variable "internal_port" {
  description = "The internal port for the application"
  type        = list(any)
  default     = ["22", "8080", "80"]
}
variable "instance_ami" {
  description = "The AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0ecb62995f68bb549"  
}
variable "instance_type" {
  description = "The instance type for the EC2 instance"
  type        = string
  default     = "t3.medium"
}
variable "availability_zone" {
  description = "The availability zone for the subnet"
  type        = string
  default     = "us-east-1a"
}
variable "key_name" {
  description = "The key pair name for SSH access"
  type        = string
  default     = "terraform-key"
}
