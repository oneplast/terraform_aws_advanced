variable "vpc_name" {
  description = "VPC 이름"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "public_subnets" {
  description = "Public Subnets IDs"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private Subnets IDs"
  type        = list(string)
}

variable "availability_zones" {
  description = "서브넷 가용 영역"
  type        = list(string)
}
