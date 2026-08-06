variable "aws_region" {
  description = "AWS 리전"
  type        = string
}

variable "aws_profile" {
  description = "AWS CLI 프로파일"
  type        = string
}

variable "owner" {
  description = "프로젝트 Owner"
  type        = string
  default     = "MyTeamA"
}

variable "environment" {
  description = "배포 환경"
  type        = string
  default     = "Production"
}

variable "vpc_name" {
  description = "VPC 이름"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "퍼블릭 서브넷 CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "프라이빗 서브넷 CIDRs"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  description = "서브넷 가용 영역"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

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
  description = "공개 키 경로"
  type        = string
}

variable "cluster_identifier" {
  description = "Aurora 클러스터 Identifier"
  type        = string
}

variable "db_engine_version" {
  description = "Aurora 엔진 버전"
  type        = string
  default     = "8.0.mysql_aurora.3.06.1"
}

variable "db_username" {
  description = "Aurora 클러스터 마스터 계정명"
  type        = string
}

variable "db_password" {
  description = "Aurora 클러스터 마스터 패스워드"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "Aurora 클러스터 인스턴스 클래스"
  type        = string
  default     = "db.t3.micro"
}

variable "allowed_cidr" {
  description = "RDS 허용 CIDR"
  type        = string
}

variable "db_cluster_snapshot_identifier" {
  description = "DB 클러스터 스냅샷 Identifier"
  type        = string
}
