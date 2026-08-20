# AWS
variable "aws_region" {
  description = "AWS 리전"
  type        = string
}

variable "aws_profile" {
  description = "AWS CLI 프로파일"
  type        = string
}

# IAM
variable "iam_user_name" {
  description = "IAM 유저명"
  type        = string
  default     = "project_member"
}

variable "s3_bucket_name" {
  description = "S3 버킷 이름"
  type        = string
}

variable "dev_role_name" {
  description = "개발 계정 역할 이름"
  type        = string
  default     = "DevEC2StatusViewer"
}

variable "prod_user_name" {
  description = "운영 계정 유저 이름"
  type        = string
  default     = "prod_user"
}

variable "ec2_view_status_role_name" {
  description = "EC2 인스턴스 상태 조회 정책 이름"
  type        = string
  default     = "EC2DescribeInstancesPolicy"
}
