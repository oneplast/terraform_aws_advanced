variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
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
  description = "태깅을 위한 프로젝트 이름"
  type        = string
}

variable "allowed_ssh_cidr_blocks" {
  description = "SSH 허가 CIDR 블록"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "redis_cidr_blocks" {
  description = "Redis 허가 CIDR 블록"
  type        = list(string)
}

variable "user_data" {
  description = "EC2에 런치할 user_data 스크립트"
  type        = string
  default     = "sudo yum install python3-pip && sudo pip3 install redis"
}

variable "ec2_instance_profile" {
  description = "EC2에 부여할 dynamodb 접근 프로파일"
  type        = string
}
