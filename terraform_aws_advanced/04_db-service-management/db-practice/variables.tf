# AWS
variable "aws_region" {
  description = "AWS 리전"
  type        = string
}

variable "aws_profile" {
  description = "AWS CLI 프로파일"
  type        = string
}

variable "project_name" {
  description = "태깅을 위한 프로젝트명"
  type        = string
  default     = "my-project"
}

# Public
variable "public_cidr" {
  description = "모두 허용 CIDR (공용)"
  type        = string
  default     = "0.0.0.0/0"
}

# VPC
variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "퍼블릭 서브넷 CIDRs"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "프라이빗 서브넷 CIDRs"
  type        = list(string)
}

variable "db_subnet_cidrs" {
  description = "DB 서브넷 CIDRs"
  type        = list(string)
}

variable "cache_subnet_cidrs" {
  description = "Cache 서버 서브넷 CIDRs"
  type        = list(string)
}

variable "availability_zones" {
  description = "서브넷 가용 영역"
  type        = list(string)
}

# DynamoDB
variable "dynamodb_table_name" {
  description = "DynamoDB 테이블명"
  type        = string
}

variable "dynamodb_hash_key" {
  description = "DynamoDB 파티션 키 (해시 키)"
  type        = string
}

variable "dynamodb_hash_key_type" {
  description = "DynamoDB 파티션 키 타입"
  type        = string
  default     = "S"
}

variable "dynamodb_range_key" {
  description = "DynamoDB 범위 키 (정렬 키)"
  type        = string
  default     = "null"
}

variable "dynamodb_range_key_type" {
  description = "DynamoDB 범위 키 타입"
  type        = string
  default     = "S"
}

variable "dynamodb_billing_mode" {
  description = "DynamoDB 지불 방식"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "dynamodb_read_capacity" {
  description = "DynamoDB RCU"
  type        = number
  default     = 5
}

variable "dynamodb_write_capacity" {
  description = "DynamoDB WCU"
  type        = number
  default     = 5
}

# Redis
variable "redis_allowed_cidrs" {
  description = "Redis 접근 가능 CIDRs"
  type        = list(string)
}

variable "redis_node_type" {
  description = "Redis 인스턴스 타입"
  type        = string
  default     = "cache.t3.micro"
}

variable "redis_num_cache_nodes" {
  description = "Redis 캐시 노드 수 (노드 그룹/샤드 수)"
  type        = number
  default     = 2
}

variable "redis_parameter_group_name" {
  description = "Redis 파라미터 그룹명"
  type        = string
  default     = "default.redis7"
}

variable "redis_auth_token" {
  description = "Redis 인증 토큰"
  type        = string
  sensitive   = true
}

# EC2
variable "ec2_ami_id" {
  description = "AMI ID"
  type        = string
}

variable "ec2_instance_type" {
  description = "EC2 인스턴스 타입"
  type        = string
  default     = "t2.micro"
}

variable "ec2_public_key_path" {
  description = "EC2 공개 키 경로"
  type        = string
}

variable "ec2_user_data" {
  description = "EC2 user_data 스크립트"
  type        = string
}
