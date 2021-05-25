terraform {

  required_version = ">= 0.14.9"

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
 
  }
  
}

provider "aws" {
  region  = "ap-south-1"
 #profile = "nginxprofile"

  assume_role {
    role_arn = "arn:aws:iam::752042071855:role/EC2FullAccess"
  }

  default_tags {

    tags = {
      Environment = "Dev"
      Email       = "balan.pothula@gmail.com"
    }

  }

}

variable "aws_region" {
  type        = string
  default     = "ap-south-1"
  description = "AWS Region"
}

variable "ami" {
  type        = map(string)
  default = {
    "ap-south-1"     = "ami-0860c9429baba6ad2"
    "ap-southeast-1" = "ami-0f9d733050c9f5365"
  }
  description = "AMI ID"
}

variable "availability_zones" {
  type        = list(string)
  default     = [
    "ap-south-1a",
    "ap-south-1b",
    "ap-south-1c"
  ]
  description = "Availability Zones"
}

variable "instance_count" {
  type        = number
  default     = 2
  description = "Instance Count"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Instance Type"
}

variable "key_name" {
  type        = string
  default     = "EC2"
  description = "Instance Private Key"
}

variable "vpc_security_group_ids" {
  type        = list(string)
  default     = ["sg-cc2fcdae"]
  description = "Security Group IDs"
}

resource "aws_instance" "nginx_server" {
  ami                    = lookup(var.ami, var.aws_region)                   # Amazon Machine Image.
  availability_zone      = "${element(var.availability_zones, count.index)}" # Availability Zone Name.
  count                  = var.instance_count                                # Number of Instances.
  instance_type          = var.instance_type                                 # EC2 Instance Type.
  key_name               = var.key_name                                      # EC2 Instance Private Key.
  vpc_security_group_ids = var.vpc_security_group_ids                        # Security Group IDs.
 #user_data              = file("install_nginx.sh")                          # User Data.
  user_data = <<-USER_DATA
    #!/bin/bash
    sudo apt -y update
    sudo apt -y install nginx
    sudo service nginx start
  USER_DATA

  tags = {
    Name = "nginx-server-${count.index}"
  }

}

output "instance_id" {
  value       = aws_instance.nginx_server.*.id
  description = "AWS Instance IDs"
}

output "instance_public_ip" {
  value       = aws_instance.nginx_server.*.public_ip
  description = "AWS Instance Public IPs"
}
