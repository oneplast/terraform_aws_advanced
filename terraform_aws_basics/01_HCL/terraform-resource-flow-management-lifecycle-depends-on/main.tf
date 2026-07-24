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
  region  = "us-east-1"
  profile = "my-profile"
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

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_security_group" "example_sg" {
  name = "example-sg"
}

resource "aws_instance" "example_create_before_destroy_with_dependency" {
  ami           = data.aws_ami.al2023.id
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_security_group.example_sg]
}

resource "random_integer" "rand_num" {
  min = 1000
  max = 9999
}

resource "aws_s3_bucket" "example_bucket" {
  bucket = "my-important-bucket-${random_integer.rand_num.result}"

  lifecycle {
    prevent_destroy = false
  }
}
