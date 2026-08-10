# AWS
variable "aws_region" {
  description = "AWS 리전"
  type        = string
}

variable "aws_profile" {
  description = "AWS CLI 프로파일"
  type        = string
}

variable "project_name" {
  description = "태깅을 위한 프로젝트명"
  type        = string
}

variable "public_key_path" {
  description = "공개 키 경로"
  type        = string
}

variable "public_cidr" {
  description = "모든 IP 허용 CIDR"
  type        = string
}

# VPC
variable "vpc_name" {
  description = "VPC 이름"
  type        = string
  default     = "my-vpc"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_public_subnets" {
  description = "VPC 퍼블릭 서브넷 ID"
  type        = list(string)
}

variable "vpc_private_subnets" {
  description = "VPC 프라이빗 서브넷 ID"
  type        = list(string)
}

# ASG
variable "asg_desired_capacity" {
  description = "ASG 기본 Capacity"
  type        = number
  default     = 2
}

variable "asg_max_capacity" {
  description = "ASG 최대 Capacity"
  type        = number
  default     = 3
}

variable "asg_min_capacity" {
  description = "ASG 최소 Capacity"
  type        = number
  default     = 1
}

# Packer
variable "packer_ami" {
  description = "Packer로 생성된 AMI"
  type        = string
}

variable "instance_type" {
  description = "EC2 인스턴스 타입"
  type        = string
  default     = "t2.micro"
}
