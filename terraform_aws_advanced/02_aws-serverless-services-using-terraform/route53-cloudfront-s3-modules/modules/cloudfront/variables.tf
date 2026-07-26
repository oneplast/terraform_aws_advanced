variable "bucket_name" {
  description = "S3 버킷 이름"
  type        = string
}

variable "bucket_id" {
  description = "S3 버킷 ID"
  type        = string
}

variable "bucket_domain_name" {
  description = "S3 버킷 도메인 이름"
  type        = string
}

variable "bucket_arn" {
  description = "S3 버킷 ARN"
  type        = string
}

variable "index_document" {
  description = "CloudFront 기본 루트 오브젝트 (예: index.html)"
  type        = string
}
