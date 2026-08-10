packer {
  required_plugins {
    amazon = {
      version = ">= 1.3.3"
      source  = "github.com/hashicorp/amazon" # AWS 공식 Hashicorp 플러그인
    }
  }
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "profile" {
  type    = string
  default = "my-profile"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

# aws ec2 describe-images --owners 099720109477 --filter "Name=name,Values=ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*" "Name=architecture,Values=x86_64"
data "amazon-ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filters = {
    name         = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
    architecture = "x86_64"
  }
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "") # 현재 시간을 문자열로 가져온 후, 허용되지 않는 문자 제거
}

# Packer의 amazon-ebs 소스 정의
source "amazon-ebs" "example" {
  profile       = var.profile
  region        = var.aws_region
  instance_type = var.instance_type
  ssh_username  = "ubuntu"                           # EC2 인스턴스 SSH 접속용 사용자
  ami_name      = "packer-ubuntu-${local.timestamp}" # 생성할 AMI 이름 (타임스탬프로 유일성 보장)
  source_ami    = data.amazon-ami.ubuntu.id
}

# 빌드 블록: AMI 생성 시 수행할 작업 정의
build {
  sources = ["source.amazon-ebs.example"]

  provisioner "shell" {
    inline = [
      "sudo apt update -y",                         # 인스턴스 패키지 업데이트
      "sudo apt install -y apache2",                # Apache 웹 서버 설치
      "sudo systemctl enable apache2 --now",        # Apace 웹 서버 서비스 활성화 및 즉시 시작
      "echo 'test index.html' > index.html",        # HTML 페이지 작성
      "sudo cp index.html /var/www/html/index.html" # HTML 파일 이동
    ]
  }
}