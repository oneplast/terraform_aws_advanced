variable "vpc_name" {
  description = "VPC 이름"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "public_subnets" {
  description = "퍼블릭 서브넷 리스트"
  type        = list(string)
}

variable "private_subnets" {
  description = "프라이빗 서브넷 리스트"
  type        = list(string)
}

variable "availability_zones" {
  description = "서브넷 가용 영역 리스트"
  type        = list(string)
}
