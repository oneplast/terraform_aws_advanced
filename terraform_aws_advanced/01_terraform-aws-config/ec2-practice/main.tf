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

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]


  filter {
    name   = "name"
    values = ["ubuntu*24.04*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# resource "aws_vpc" "vpc" {
#   cidr_block           = var.vpc_cidr_block
#   enable_dns_hostnames = true
#   enable_dns_support   = true

#   tags = {
#     Name = "MyVPC"
#   }
# }

resource "aws_subnet" "public_subnet" {
  vpc_id            = module.aws_vpc.vpc_id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.subnet_az

  tags = {
    Name = "MyPublicSubnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = module.aws_vpc.vpc_id

  tags = {
    Name = "MyInternetGateway"
  }
}

resource "aws_route_table" "route_tb" {
  vpc_id = module.aws_vpc.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "MyRouteTable"
  }
}

resource "aws_route_table_association" "route_tb_associate" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.route_tb.id
}

resource "aws_security_group" "sg" {
  vpc_id = module.aws_vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MySecurityGroup"
  }
}

resource "aws_instance" "ec2" {
  count                       = 3
  ami                         = data.aws_ami.ubuntu.id
  subnet_id                   = module.aws_vpc.public_subnets[count.index]
  instance_type               = var.instance_type
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.sg.id]

  root_block_device {
    volume_size           = 30
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "MyFirstInstance-${count.index + 1}"
  }
}

######################################
# VPC 설정
######################################
locals {
  aws_zone_mapping = {
    "us-east-1" = ["a", "b", "c"]
  }
  azs = [for az in local.aws_zone_mapping[var.aws_region] : "${var.aws_region}${az}"]
}

module "aws_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.21.0"

  name = "my-vpc"
  cidr = var.vpc_cidr_block

  azs             = local.azs
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = false
  single_nat_gateway = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
