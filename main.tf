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

  access_key = "your_access_key"
  secret_key = "your_secret_key"

//profile = "terraform"

/*
  assume_role {
    role_arn = "arn:aws:iam::123456789012:role/terraform"
  }
*/

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
  default     = 1
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

resource "aws_instance" "platform" {
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
    sudo apt -y install nginx software-properties-common
    sudo add-apt-repository -y ppa:deadsnakes/ppa
    sudo apt -y update
    sudo apt -y install python3.8
    sudo service nginx start
  USER_DATA

  tags = {
    Name = "platform-${count.index}"
  }

}

output "instance_id" {
  value       = aws_instance.platform.*.id
  description = "AWS Instance IDs"
}

output "instance_public_ip" {
  value       = aws_instance.platform.*.public_ip
  description = "AWS Instance Public IPs"
}
