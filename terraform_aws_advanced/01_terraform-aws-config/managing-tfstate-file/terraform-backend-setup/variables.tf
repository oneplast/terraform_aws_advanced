variable "aws_region" {
  description = "AWS 리소스를 배포할 리전"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "사용할 AWS CLI 프로필"
  type        = string
  default     = "my-profile"
}

variable "environment" {
  description = "배포 환경 설정 (예: dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "s3_bucket_name" {
  description = "Terraform 상태 파일을 저장할 S3 버킷 이름"
  type        = string
  default     = "my-terraform-state-bucket-oneplast"
}

variable "dynamodb_table_name" {
  description = "Terraform 상태 잠금에 사용할 DynamoDB 테이블 이름"
  type        = string
  default     = "terraform-state-lock-oneplast"
}
