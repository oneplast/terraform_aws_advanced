terraform {
  required_version = ">= 1.9.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.73.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "my_ec2" {
  ami           = data.aws_ami.al2023.id
  instance_type = var.instance_type

  tags = {
    Name        = "MyEC2Instance"
    Environment = var.environment
  }
}
