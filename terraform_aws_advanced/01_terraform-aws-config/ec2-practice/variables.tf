variable "aws_region" {
  description = "AWS 리전"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS 인증 프로파일"
  type        = string
  default     = "my-profile"
}

variable "vpc_cidr_block" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  description = "퍼블릭 서브넷 CIDR"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_az" {
  description = "서브넷 가용 영역"
  type        = string
  default     = "us-east-1a"
}

variable "instance_type" {
  description = "EC2 인스턴스 타입"
  type        = string
  default     = "t2-micro"
}
