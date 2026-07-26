#################################
# VPC 설정
#################################
locals {
  aws_zone_mapping = {
    "us-east-1" = ["a", "b", "c"]
  }

  azs = [for az in local.aws_zone_mapping[var.aws_region] : "${var.aws_region}${az}}"]
}

module "my_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.15.0"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

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

#################################
# EC2 설정
#################################
resource "random_integer" "key_suffix" {
  min = 1000
  max = 9999
}

resource "aws_key_pair" "generated_key_pair" {
  key_name   = "my-key-${random_integer.key_suffix.result}"
  public_key = file(pathexpand(var.pub_key_file_path))
}

# 보안 그룹 생성 (SSH, DNS 쿼리 허용)
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "Allow SSH and DNS traffic"
  vpc_id      = module.my_vpc.vpc_id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow DNS"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
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

resource "aws_instance" "dns_test_instance" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = var.instance_type
  subnet_id                   = module.my_vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  key_name                    = aws_key_pair.generated_key_pair.key_name
  associate_public_ip_address = true

  tags = {
    Name = "PrivateDNS-Test-Instance"
  }
}

#################################
# Route53 설정
#################################
# Route53 Private Hosted Zone 생성 (VPC와 연결된 Private DNS 영역)
resource "aws_route53_zone" "private_dns" {
  name = var.private_dns_name
  vpc {
    vpc_id = module.my_vpc.vpc_id
  }
  comment = "Private DNS zone for ${var.private_dns_name}"
}

# CloudFront 도메인 이름을 가리키는 A 레코드 생성
resource "aws_route53_record" "alias_record" {
  zone_id = aws_route53_zone.private_dns.id
  name    = var.private_dns_name
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }

  set_identifier = "cloudfront-record-1"

  weighted_routing_policy {
    weight = 100
  }
}
