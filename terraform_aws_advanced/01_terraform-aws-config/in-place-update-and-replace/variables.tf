variable "aws_region" {
  description = "리소스를 배포할 AWS 리전"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS CLI에서 사용할 프로필"
  type        = string
  default     = "my-profile"
}

variable "environment" {
  description = "배포 환경 설정 (예: dev, staging, prod)"
  type        = string
  default     = "prod"
}

variable "public_key_path" {
  description = "기존 SSH 공개 키의 경로"
  type        = string
  default     = "~/.ssh/my-key.pub"
}
