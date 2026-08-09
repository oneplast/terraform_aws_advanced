variable "aws_region" {
  description = "AWS 리전"
  type        = string
}

variable "aws_profile" {
  description = "AWS CLI 프로파일"
  type        = string
}

variable "environment" {
  description = "배포 환경"
  type        = string
}

variable "owner" {
  description = "리소스 담당자"
  type        = string
  default     = "TeamA"
}

# DynamoDB
variable "table_name" {
  description = "DynamoDB 테이블명"
  type        = string
  default     = "Users"
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

variable "project" {
  description = "DynamoDB 프로젝트 태그"
  type        = string
  default     = "UserManagement"
}
