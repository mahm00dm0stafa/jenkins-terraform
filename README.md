# Jenkins Server Deployment on AWS using Terraform

This project automates the deployment of a fully functional **Jenkins server** on AWS using **Terraform**. The setup includes a custom VPC, public subnet, routing configuration, security group, EC2 instance, Elastic IP, and automatic Jenkins installation through a user data script.

---

## 📌 Project Overview

The Terraform configuration performs the following tasks:

* Creates a **custom VPC** with DNS support enabled.
* Sets up a **public subnet** in a specified Availability Zone.
* Attaches an **Internet Gateway** to allow outbound internet traffic.
* Creates and associates a **public route table**.
* Builds a **Security Group** that allows SSH, HTTP, and Jenkins ports.
* Generates a **Key Pair** for SSH access.
* Deploys an **EC2 instance** with:

  * Ubuntu AMI
  * Jenkins auto-installation using `install_jenkins.sh`
  * Encrypted root volume
* Allocates and attaches an **Elastic IP (EIP)** to the instance.
* Outputs the final Jenkins URL.

---

## 🗂 Project Structure

```
├── main.tf                 # All AWS infrastructure resources
├── variables.tf            # Input variables
├── output.tf               # Output (Jenkins URL)
├── provider_aws.tf         # AWS provider configuration
├── install_jenkins.sh      # User data script to install Jenkins
├── AUTHOR.md               # Author information 
└── README.md               # Project documentation
```

---

## ⚙️ Requirements

Before deploying the project, ensure you have:

* **Terraform v1.0+** installed
* **AWS CLI configured** with valid credentials
* A **public SSH key** at: `~/.ssh/terraform-key.pub`
* An AWS IAM user with permissions for:

  * VPC
  * EC2
  * Elastic IP
  * Security groups

---

## 🧪 How to Deploy

### 1. Clone the repository

```bash
git clone https://github.com/mahm00dm0stafa/jenkins-terraform.git
cd jenkins-terraform
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Review and validate configuration

```bash
terraform validate
terraform plan
```

### 4. Apply the changes

```bash
terraform apply -auto-approve
```

### 5. Access Jenkins

After provisioning completes, Terraform will output your Jenkins URL:

```
http://<Elastic-IP>:8080
```

Visit the URL in your browser.

You can retrieve the Jenkins default admin password with:

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

---

## 🧹 Destroying the Infrastructure

To delete all created resources:

```bash
terraform destroy -auto-approve
```

---

**Enjoy your automated Jenkins deployment! 🚀**
