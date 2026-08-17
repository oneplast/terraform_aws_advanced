# AWS
variable "aws_region" {
  description = "AWS 리전"
  type        = string
}

variable "aws_profile" {
  description = "AWS CLI 프로파일"
  type        = string
}

# AMI ID (AMI 생성 이후 변경)
variable "ami_id" {
  description = "Packer 이후 생성된 AMI ID"
  type        = string
}

# VPC
variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_public_subnets_cidrs" {
  description = "VPC 퍼블릭 서브넷 CIDRs"
  type        = list(string)
}

variable "vpc_private_subnets_cidrs" {
  description = "VPC 프라이빗 서브넷 CIDRs"
  type        = list(string)
}

variable "vpc_db_subnets_cidrs" {
  description = "VPC RDS 서브넷 CIDRs"
  type        = list(string)
}

# RDS
variable "db_storage" {
  description = "RDS 스토리지 용량 (GiB)"
  type        = number
  default     = 20
}

variable "db_storage_type" {
  description = "RDS 스토리지 타입"
  type        = string
}

variable "db_engine" {
  description = "RDS 엔진"
  type        = string
}

variable "db_engine_version" {
  description = "RDS 엔진 버전"
  type        = string
}

variable "db_instance_class" {
  description = "RDS 인스턴스 클래스"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "RDS 이름"
  type        = string
}

variable "db_username" {
  description = "RDS 마스터 계정"
  type        = string
}

variable "db_password" {
  description = "RDS 마스터 계정 패스워드"
  type        = string
  sensitive   = true
}

variable "db_parameter_group_name" {
  description = "RDS 파라미터 그룹이름"
  type        = string
  default     = "default.mysql8.0"
}
