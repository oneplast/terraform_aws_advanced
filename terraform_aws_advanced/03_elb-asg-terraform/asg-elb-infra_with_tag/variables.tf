variable "aws_region" {
  description = "AWS 리전"
  type        = string
}

variable "aws_profile" {
  description = "AWS CLI 프로파일"
  type        = string
}

variable "pub_key_file_path" {
  description = "퍼블릭 키 파일 경로"
  type        = string
}

variable "instance_type" {
  description = "EC2 인스턴스 유형"
  type        = string
  default     = "t2.micro"
}

# 원하는 오토 스케일링 그룹의 크기를 정의
variable "desired_capacity" {
  description = "오토 스케일링 그룹의 원하는 용량"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "오토 스케일링 그룹의 최대 크기"
  type        = number
  default     = 3
}

variable "min_size" {
  description = "오토 스케일링 그룹의 최소 크기"
  type        = number
  default     = 1
}
