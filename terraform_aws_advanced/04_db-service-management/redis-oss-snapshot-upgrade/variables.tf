# AWS
variable "aws_region" {
  description = "AWS 리전"
  type        = string
}

variable "aws_profile" {
  description = "AWS CLI 프로파일"
  type        = string
}

# VPC
variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "private_subnet_cidrs" {
  description = "프라이빗 서브넷 CIDRs"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "퍼블릭 서브넷 CIDRs"
  type        = list(string)
}

variable "availability_zones" {
  description = "서브넷 가용 영역 리스트"
  type        = list(string)
}

variable "project_name" {
  description = "태깅을 위한 프로젝트명"
  type        = string
}

# Redis
variable "redis_allowed_cidr_blocks" {
  description = "Redis 접근을 위한 CIDRs"
  type        = list(string)
}

variable "redis_node_type" {
  description = "Redis 인스턴스 타입"
  type        = string
  default     = "cache.tt3.micro"
}

variable "redis_num_cache_nodes" {
  description = "Redis 캐시 노드 수"
  type        = number
  default     = 1
}

variable "redis_parameter_group_name" {
  description = "Redis 파라미터 그룹명"
  type        = string
  default     = "default.redis7"
}

variable "redis_auth_token" {
  description = "Redis 인증 토큰"
  type        = string
}
