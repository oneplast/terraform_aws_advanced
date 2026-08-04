variable "aws_region" {
  description = "AWS 리전"
  type        = string
}

variable "aws_profile" {
  description = "AWS CLI 프로파일"
  type        = string
}

variable "environment" {
  description = "RDS 인스턴스 환경"
  type        = string
  default     = "Production"
}

variable "vpc_name" {
  description = "VPC 이름"
  type        = string
  default     = "my-vpc"
}

variable "vpc_cidr" {
  description = "VPC CIDR 블록"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "퍼블릭 서브넷 CIDR 리스트"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "프라이빗 서브넷 CIDR 리스트"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  description = "서브넷 가용 영역 존"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

###########
# RDS 변수
###########

variable "allowed_cidr" {
  description = "RDS 인스턴스 CIDR 블록"
  type        = string
}

variable "db_allocated_storage" {
  description = "RDS 할당 스토리지 용량 (GB)"
  type        = number
  default     = 20
}

variable "db_engine_version" {
  description = "DB 엔진 버전"
  type        = string
  default     = "8.0"
}

variable "db_instance_class" {
  description = "RDS 인스턴스 클래스"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "DB 이름"
  type        = string
}

variable "db_username" {
  description = "DB 마스터 유저이름"
  type        = string
}

variable "db_password" {
  description = "DB 마스터 패스워드"
  type        = string
  sensitive   = true
}

variable "db_parameter_group_name" {
  description = "DB 파라미터 그룹 이름"
  type        = string
  default     = "default.mysql8.0"
}

variable "db_multi_az" {
  description = "다중 가용영역 사용 여부"
  type        = bool
  default     = false
}

########
# EC2
########

variable "instance_type" {
  description = "EC2 인스턴스 타입"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "EC2 인스턴스 이름"
  type        = string
}

variable "public_key_path" {
  description = "퍼블릭 키 경로"
  type        = string
}
