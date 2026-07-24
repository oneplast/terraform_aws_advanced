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
  default     = "dev"
}

variable "instance_type" {
  description = "생성할 인스턴스 유형"
  type        = string
  default     = "t2.micro"
}
