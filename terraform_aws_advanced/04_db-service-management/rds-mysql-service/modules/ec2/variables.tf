variable "ami_id" {
  description = "AMI ID"
  type        = string
}

variable "instance_type" {
  description = "인스턴스 타입"
  type        = string
}

variable "subnet_id" {
  description = "서브넷 ID"
  type        = string
}

variable "public_key_path" {
  description = "퍼블릭 키 경로"
  type        = string
}

variable "instance_name" {
  description = "인스턴스 이름"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
