######################################
# VPC 설정
######################################
locals {
  aws_zone_mapping = {
    "us-east-1" = ["a", "b", "c"]
  }

  azs = [for az in local.aws_zone_mapping[var.aws_region] : "${var.aws_region}${az}"]
}

module "my_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.15.0"

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

######################################
# EC2 설정
######################################
resource "random_integer" "key_suffix" {
  min = 1000
  max = 9999
}

# 키 페어 설정
resource "aws_key_pair" "generated_key_pair" {
  key_name   = "my-key-${random_integer.key_suffix.result}"
  public_key = file(var.pub_key_file_path)
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
    protocol    = "tcp"
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

######################################
# Route53 설정
# - Route53 Priavte Hosted Zone 생성 (VPC와 연결된 Private DNS 영역)
######################################
resource "aws_route53_zone" "private_dns" {
  name = var.private_dns_name # Priavte Hosted Zone의 도메인 이름

  # vpc 블록이 없으면, 기본적으로 Public Hosted Zone 생성
  # vpc 블록이 하나라도 존재하면, 지정한 VPC와 연결된 Private Hosted Zone 생성
  vpc {
    vpc_id = module.my_vpc.vpc_id # Private Hosted Zone을 연결할 VPC ID
  }
  comment = "Private DNS zone for ${var.private_dns_name}" # Hosted Zone에 대한 설명
}

# Private Hosted Zone에 A 레코드 생성
# test_record_ip_1에 대한 A 레코드 생성 (가중치 5)
resource "aws_route53_record" "test_record_1" {
  zone_id        = aws_route53_zone.private_dns.zone_id # 레코드를 생성할 Hosted Zone ID
  name           = var.private_dns_name                 # 레코드의 이름 (FQDN 형식)
  type           = "A"                                  # 레코드 유형 (A 레코드 - IP 주소 가리킴)
  ttl            = 300                                  # 레코드의 TTL(Time To Live) 설정(초)
  records        = [var.test_record_ip_1]               # 레코드가 가리킬 첫 번째 IP 주소
  set_identifier = "test_record_ip_1"                   # 레코드 식별자 (가중치 설정에 필요)

  weighted_routing_policy {
    weight = 5 # 가중치 설정 (5)
  }
}

# test_record_ip_2에 대한 A 레코드 생성 (가중치 5)
resource "aws_route53_record" "test_record_2" {
  zone_id        = aws_route53_zone.private_dns.zone_id # 레코드를 생성할 Hosted Zone Id
  name           = var.private_dns_name                 # 레코드의 이름 (FQDN 형식)
  type           = "A"                                  # 레코드 유형 (A 레코드 - IP 주소 가리킴)
  ttl            = 300                                  # 레코드의 TTL(Time To Live) 설정 (초)
  records        = [var.test_record_ip_2]               # 레코드가 가리킬 두 번째 IP 주소
  set_identifier = "test_record_ip_2"                   # 레코드 식별자 (가중치 설정에 필요)

  weighted_routing_policy {
    weight = 5 # 가중치 설정 (5)
  }
}
