variable "aws_region" {
  description = "AWS 리전"
  type        = string
}

variable "aws_profile" {
  description = "AWS CLI 프로파일"
  type        = string
}

# IAM 유저 이름 변수
variable "ec2_user_name" {
  description = "EC2 management 권한을 사용할 IAM 유저명"
  type        = string
  default     = "ec2_user"
}

# IAM 그룹 이름 변수
variable "ec2_group_name" {
  description = "EC2 management 권한을 사용할 IAM 그룹명"
  type        = string
  default     = "ec2-managers"
}
