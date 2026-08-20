variable "aws_region" {
  description = "AWS 리전"
  type        = string
}

variable "aws_profile" {
  description = "AWS CLI 프로파일"
  type        = string
}

variable "group_name" {
  description = "팀 이름"
  type        = string
}

variable "user_display_name" {
  description = "유저 이름"
  type        = string
}

variable "user_given_name" {
  description = "이름"
  type        = string
}

variable "user_family_name" {
  description = "성"
  type        = string
}

variable "principal_type" {
  description = "Principal 타입 (USER || GROUP)"
  type        = string
  default     = "USER"
}

variable "user_email" {
  description = "프로파일에 추가할 이메일 정보, 여기로 계정 정보가 전달됨"
  type        = string
}

data "aws_caller_identity" "current" {}

/*
variable "aws_account_id" {
  description = "Permission set이 할당될 AWS 계정 ID"
  type        = string
  default     = data.aws_caller_identity.current.account_id
}
*/

variable "sso_instance_arn" {
  description = "AWS CLI를 사용해 SSO 인스턴스의 ARN을 가져옴"
  type        = string
}

variable "identity_store_id" {
  description = "AWS CLIF를 사용해 Identity Store ID를 가져옴"
  type        = string
}
