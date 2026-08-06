variable "ami_id" {
  description = "EC2 AMI ID"
  type        = string
}

variable "instance_type" {
  description = "EC2 인스턴스 타입"
  type        = string
}

variable "subnet_id" {
  description = "EC2 서브넷 ID"
  type        = string
}

variable "public_key_path" {
  description = "공개 키 경로"
  type        = string
}

variable "instance_name" {
  description = "EC2 인스턴스 이름"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
