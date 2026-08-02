variable "aws_region" {
  description = "AWS 리전"
  type        = string
}

variable "aws_profile" {
  description = "AWS CLI 프로파일"
  type        = string
}

variable "pub_key_file_path" {
  description = "퍼블릭 키 경로"
  type        = string
}

variable "instance_type" {
  description = "EC2 인스턴스 타입"
  type        = string
  default     = "t2.micro"
}

variable "desired_capacity" {
  description = "오토 스케일링 그룹 기본 크기"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "오토 스케일링 그룹 최대 크기"
  type        = number
  default     = 3
}

variable "min_size" {
  description = "오토 스케일링 그룹 최소 크기"
  type        = number
  default     = 1
}

variable "private_key_file_path" {
  description = "비밀 키 경로"
  type        = string
}

variable "certificate_body_file_path" {
  description = "인증서 경로"
  type        = string
}
