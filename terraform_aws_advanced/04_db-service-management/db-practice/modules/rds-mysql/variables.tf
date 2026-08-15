variable "rds_cidr" {
  description = "RDS CIDR"
  type        = string
}

variable "engine_version" {
  description = "RDS 엔진 버전"
  type        = string
  default     = "8.0"
}

variable "instance_class" {
  description = "RDS 인스턴스 클래스"
  type        = string
  default     = "db.t3.micro"
}

variable "rds_storage" {
  description = "RDS 스토리지 용량"
  type        = number
  default     = 20
}

variable "rds_storage_type" {
  description = "RDS 스토리지 타입"
  type        = string
  default     = "gp2"
}

variable "db_name" {
  description = "RDS 이름"
  type        = string
}

variable "db_username" {
  description = "RDS 마스터 유저명"
  type        = string
}

variable "db_password" {
  description = "RDS 마스터 패스워드"
  type        = string
  sensitive   = true
}

variable "db_parameter_group" {
  description = "RDS 파라미터 그룹"
  type        = string
  default     = "default.mysql8.0"
}

variable "db_multi_az" {
  description = "RDS 멀티 AZ 여부"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "DynamoDB 엔드포인트에 접근할 수 있는 프라이빗 서브넷 IDs"
  type        = list(string)
}
