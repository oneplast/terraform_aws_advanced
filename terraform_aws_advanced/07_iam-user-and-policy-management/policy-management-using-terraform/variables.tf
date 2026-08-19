variable "aws_region" {
  description = "AWS 리전"
  type        = string
}

variable "aws_profile" {
  description = "AWS CLI 프로파일"
  type        = string
}

variable "user_name" {
  description = "IAM 유저명"
  type        = string
  default     = "example_user"
}

variable "s3_policy_file" {
  description = "S3 read-only 정책 JSON 파일명"
  type        = string
  default     = "s3-readonly-policy.json"
}
