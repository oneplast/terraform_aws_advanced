variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "허가된 CIDR"
  type        = list(string)
}

variable "project_name" {
  description = "태깅을 위한 프로젝트명"
  type        = string
}

variable "private_subnet_ids" {
  description = "프라이빗 서브넷 IDs"
  type        = list(string)
}

variable "cluster_id" {
  description = "Redis 클러스터 ID"
  type        = string
  default     = "my-redis-cluster"
}

variable "node_type" {
  description = "Redis 인스턴스 유형"
  type        = string
  default     = "cache.t3.micro"
}

variable "engine" {
  description = "클러스터 엔진"
  type        = string
  default     = "valkey"
}

variable "parameter_group_name" {
  description = "파라미터 그룹명"
  type        = string
  default     = "default.redis7"
}

variable "cluster_mode" {
  description = "클러스터 모드 활성화 여부"
  type        = string
  default     = "enabled"
}

variable "num_of_node_group" {
  description = "노드 그룹 수"
  type        = number
  default     = 2
}

variable "num_of_replica_nodes" {
  description = "복제 노드 수"
  type        = number
  default     = 1
}

variable "redis_auth_token" {
  description = "레디스 인증 토큰 (비밀번호)"
  type        = string
  sensitive   = true
}
