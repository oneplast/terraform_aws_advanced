# Provider
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

# VPC2
locals {
  aws_zone_mapping = {
    "us-east-1" = ["a", "b", "c"]
  }

  azs = [for az in local.aws_zone_mapping[var.aws_region] : "${var.aws_region}${az}"]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.21.0"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = local.azs
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_security_group" "my_sg" {
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2
resource "aws_instance" "my_ec2" {
  count                       = 3
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.small"
  key_name                    = aws_key_pair.my_key_pari.key_name
  subnet_id                   = module.vpc.public_subnets[count.index]
  vpc_security_group_ids      = [aws_security_group.my_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "MyFirstInstance-${count.index + 1}" # 인스턴스의 이름 태그
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical의 공식 AWS 계정 ID (주석 처리)

  filter {
    name   = "name"                                                          # 이름 필터 설정
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"] # Ubuntu 24.04 AMI 검색
  }

  filter {
    name   = "architecture" # 아키텍처 필터 설정
    values = ["x86_64"]     # 64비트 아키텍처
  }
}

resource "random_string" "key_name_suffix" {
  length  = 8
  special = false
  upper   = false
}

# 공개 키 파일 읽기
data "local_file" "public_key" {
  filename = pathexpand("~/.ssh/my-key.pub") # 로컬 공개 키 파일 경로 설정
}

resource "aws_key_pair" "my_key_pari" {
  key_name   = "my-key-${random_string.key_name_suffix.result}"
  public_key = data.local_file.public_key.content

  tags = {
    Name = "MyKeyPair-${random_string.key_name_suffix.result}"
  }
}
