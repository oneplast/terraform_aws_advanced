variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_id" {
  description = "EC2 서브넷 ID"
  type        = string
}

variable "ami_id" {
  description = "AMI ID"
  type        = string
}

variable "instance_type" {
  description = "EC2 인스턴스 타입"
  type        = string
  default     = "t2.micro"
}

variable "public_key_path" {
  description = "공개 키 경로"
  type        = string
}

variable "project_name" {
  description = "태깅을 위한 프로젝트명"
  type        = string
}

variable "public_cidrs" {
  description = "공용 CIDRs"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "redis_cidrs" {
  description = "Redis 허용 CIDRs"
  type        = list(string)
}

variable "user_data" {
  description = "EC2 user_data 스크립트"
  type        = string
  default     = "sudo yum install -y python3-pip && sudo pip3 install redis"
}

variable "ec2_instance_profile" {
  description = "EC2에 부여할 DynamoDB 접근 프로파일"
  type        = string
}
