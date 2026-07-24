variable "aws_region" {
  description = "리소스를 생성할 AWS 리전"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "사용할 AWS CLI 프로파일"
  type        = string
  default     = "my-profile"
}

variable "bucket_name" {
  description = "S3 버킷 이름"
  type        = string
}

variable "index_document" {
  description = "인덱스 문서의 이름 (예: index.html)"
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = "에러 문서의 이름 (예: error.html)"
  type        = string
  default     = "error.html"
}

variable "index_document_path" {
  description = "로컬 인덱스 문서 파일의 경로"
  type        = string
}

variable "error_document_path" {
  description = "로컬 에러 문서 파일의 경로"
  type        = string
}

variable "environment" {
  description = "버킷의 환경 태그 (예: dev, prod)"
  type        = string
  default     = "dev"
}
