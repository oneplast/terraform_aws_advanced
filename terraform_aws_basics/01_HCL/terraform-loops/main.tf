terraform {
  required_version = ">=1.9.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.73.0"
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

# 예시 1: count를 사용한 반복
resource "aws_instance" "example1" {
  count         = 3
  ami           = data.aws_ami.al2023.id
  instance_type = "t2.micro"

  tags = {
    Name = "Example-Instance-${count.index}"
  }
}
# 예시 2: for-each를 사용한 반복
resource "aws_instance" "example2" {
  for_each      = toset(["dev", "staging", "prod"])
  ami           = data.aws_ami.al2023.id
  instance_type = "t2.micro"

  tags = {
    Name = "Example-Instance-${each.key}"
  }
}

# 예시 3: for 표현식을 사용한 값 설정
locals {
  name_tags = [for name in var.instance_names : "Name-${name}"]
}

# 예시 4: dynamic 블록을 사용한 리소스 생성
resource "aws_security_group" "example" {
  name = "example-sg"

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}
