variable "aws_region" {
  description = "AWS 리전"
  type        = string
}

variable "aws_profile" {
  description = "AWS CLI 프로파일"
  type        = string
}

variable "ami_id" {
  description = "AMI ID"
  type        = string
}

variable "asg_tag" {
  description = "ASG Tag"
  type        = string
}

variable "pub_key_file_path" {
  description = "퍼블릭 키 경로"
  type        = string
}

variable "instance_type" {
  description = "인스턴스 타입"
  type        = string
  default     = "t2.micro"
}

variable "desired_capacity" {
  description = "ASG 실행 중인 인스턴스 개수"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "ASG 최고 인스턴스 개수"
  type        = number
  default     = 3
}

variable "min_size" {
  description = "ASG 최소 인스턴스 개수"
  type        = number
  default     = 1
}

# 개인 키 입력
variable "private_key_file_path" {
  description = "개인 키 경로"
  type        = string
}

# 인증서 경로
variable "certificate_body_file_path" {
  description = "인증서 경로"
  type        = string
}

# 인증서 체인 파일 경로 (생략 가능)
# variable "certificate_chain_file_path" {
#   description = "인증서 체인 파일 경로"
#   type        = string
# }
