variable "aws_region" {
  description = "리소스 생성 AWS 리전"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "사용할 AWS CLI 프로파일 이름"
  type        = string
  default     = "my-profile"
}

variable "bucket_name" {
  description = "S3 버킷 기본 이름"
  type        = string
  default     = "my-static-website-bucket"
}

variable "index_document" {
  description = "웹사이트 첫 화면에 보여줄 파일 이름"
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = "페이지를 찾을 수 없을 때 보여줄 오류 파일 이름"
  type        = string
  default     = "error.html"
}

variable "www_dir" {
  description = "웹사이트 파일(HTML, CSS, JS 등)이 들어있는 로컬 디렉토리 경로"
  type        = string
  default     = "./www"
}

variable "environment" {
  description = "배포 환경 구분 태그"
  type        = string
  default     = "dev"
}
