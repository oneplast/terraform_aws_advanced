variable "vpc_name" {
  description = "VPC 이름"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR Block"
  type        = string
}

variable "public_subnets" {
  description = "Public Subnet CIDR Block List"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private Subnet CIDR Block List"
  type        = list(string)
}

variable "availability_zones" {
  description = "Subnet Availability Zone List"
  type        = list(string)
}
