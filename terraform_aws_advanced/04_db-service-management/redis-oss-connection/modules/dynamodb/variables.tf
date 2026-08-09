variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "DynamoDB가 접근할 프라이빗 서브넷 IDs"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "프라이빗 서브넷 CIDRs"
  type        = list(string)
}

variable "region" {
  description = "AWS 리전"
  type        = string
}

variable "project_name" {
  description = "태깅을 위한 프로젝트 이름"
  type        = string
}

variable "table_name" {
  description = "DynamoDB 테이블명"
  type        = string
}

variable "hash_key" {
  description = "DynamoDb 테이블 해시 키"
  type        = string
}

variable "hash_key_type" {
  description = "DynamoDb 테이블 해시 키 타입 (e.g., S, N)"
  type        = string
  default     = "S"
}

variable "range_key" {
  description = "DynamoDB 테이블 범위 키 (Sort Key)"
  type        = string
  default     = "null"
}

variable "range_key_type" {
  description = "DynamoDB 테이블 범위 키 타입 (e.g., S, N)"
  type        = string
  default     = "S"
}

variable "billing_mode" {
  description = "DynamoDB 지불 방식 (PROVISIONED, PAY_PER_REQUEST)"
  type        = string
  default     = "PAY_PER_REQUEST"
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
