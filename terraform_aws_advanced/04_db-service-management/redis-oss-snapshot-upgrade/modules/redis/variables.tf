variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "프라이빗 서브넷 IDs"
  type        = list(string)
}

variable "project_name" {
  description = "태깅을 위한 프로젝트명"
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "Redis 접근 가능 CIDRs"
  type        = list(string)
}

variable "node_type" {
  description = "Redis 노드 타입"
  type        = string
  default     = "cache.t3.micro"
}

variable "num_cache_nodes" {
  description = "Redis 캐시 노드 수"
  type        = number
  default     = 1
}

variable "parameter_group_name" {
  description = "Redis 파라미터 그룹 이름"
  type        = string
  default     = "default.redis7"
}

variable "redis_auth_token" {
  description = "Redis 인증 토큰"
  type        = string
}
