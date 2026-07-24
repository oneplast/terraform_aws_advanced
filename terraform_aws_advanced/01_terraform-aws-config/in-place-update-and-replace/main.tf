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

# Ubuntu 24.04 AMI ID를 가져오는 data 블록 (출시 후 사용 가능)
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu", "24.04"] # Ubuntu 24.04 AMI 검색
  }

  filter {
    name   = "architecture"
    values = ["x86_64"] # 64비트 아키텍처
  }
}

# 부트스트랩 스크립트를 로컬 변수로 정의 (Nginx 설치)
locals {
  bootstrap_script = <<-EOT
    #!/bin/bash
    yum install -y nginx
    systemctl start nginx
    echo "Hello, Nginx!" > /usr/share/nginx/html/index.html
  EOT
}

# 부트스트랩 스크립트를 로컬 변수로 정의 (Httpd 설치)
locals {
  bootstrap_script = <<-EOT
    #!/bin/bash
    yum install -y httpd
    systemctl start httpd
    echo "Hello, Httpd!" > /var/www/html/index.html
  EOT
}

# 부트스트랩 스크립트가 변경될 때마다 null_resource를 실행
resource "null_resource" "trigger_bootstrap_change" {
  triggers = {
    bootstrap_script = local.bootstrap_script
  }
}

resource "aws_instance" "my_ec2" {
  # 사용할 AMI ID - AMI ID 변경 시 - replcace 업데이트
  ami           = true ? data.aws_ami.al2023.id : data.aws_ami.ubuntu.id
  instance_type = "t2.micro" # 인스턴스 유형 설정 - in-place 업데이트

  # 태그 이름 - in-place 업데이트
  tags = {
    Name        = "MyEC2Instance"
    Environment = "dev"
  }

  # 사용할 key 이름 - replace 업데이트
  key_name = aws_key_pair.my_key_pair.key_name

  # 부트스트랩 스크립트를 user_data에 적용 - in-place 업데이트
  user_data = local.bootstrap_script

  # 부트스트랩 스크립트 변경 시 EC2 인스턴스가 replace 되도록 설정
  # 강제 replace를 구성하지 않으면 재시작만 되면서 user_data 설정 충돌
  lifecycle {
    replace_triggered_by = [null_resource.trigger_bootstrap_change]
  }
}

resource "random_string" "key_name_suffix" {
  length  = 8
  special = false
  upper   = false
}

# 공개 키 파일 읽기
data "local_file" "public_key" {
  filename = var.public_key_path # 로컬 공개 키 파일 경로 설정
}

resource "aws_key_pair" "my_key_pair" {
  key_name   = "my-key-${random_string.key_name_suffix.result}"
  public_key = data.local_file.public_key.content

  tags = {
    Name = "MyKeyPair-${random_string.key_name_suffix.result}"
  }
}
