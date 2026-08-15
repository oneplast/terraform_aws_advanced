variable "billing_mode" {
  description = "지불 방식"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "table_name" {
  description = "테이블 이름"
  type        = string
  default     = "Products"
}

variable "hash_key" {
  description = "파티션 키"
  type        = string
  default     = "product_id"
}

variable "hash_key_type" {
  description = "파티션 키 타입"
  type        = string
  default     = "S"
}

variable "range_key" {
  description = "범위 키 (정렬 키)"
  type        = string
}

variable "range_key_type" {
  description = "범위 키 타입"
  type        = string
  default     = "S"
}

variable "read_capacity" {
  description = "RCU"
  type        = number
  default     = 5
}

variable "write_capacity" {
  description = "WCU"
  type        = number
  default     = 5
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "DynamoDB 엔드포인트에 접근할 수 있는 프라이빗 서브넷 IDs"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "프라이빗 서브넷 CIDRs"
  type        = list(string)
}

variable "aws_region" {
  description = "AWS 리전"
  type        = string
}

variable "project_name" {
  description = "태깅을 위한 프로젝트명"
  type        = string
}
