terraform {
  required_version = ">= 1.9.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.73.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

resource "random_integer" "bucket_suffix" {
  min = 1000
  max = 9999
}

resource "aws_s3_bucket" "static_site" {
  bucket = "${var.bucket_name}-${random_integer.bucket_suffix.result}"

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

# S3 버킷의 정적 웹사이트 설정 구성
resource "aws_s3_bucket_website_configuration" "static_site_website" {
  bucket = aws_s3_bucket.static_site.id

  index_document {
    suffix = var.index_document
  }

  error_document {
    key = var.error_document
  }
}

# S3 버킷의 Public Access Block 설정 해제
resource "aws_s3_bucket_public_access_block" "static_site_public_access_block" {
  bucket = aws_s3_bucket.static_site.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# S3 버킷에 대한 정책 설정
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.static_site.id

  # depends_on을 통해 S3 버킷과 Public Access Block 설정이 완료된 후에 정책을 적용
  depends_on = [
    aws_s3_bucket.static_site,
    aws_s3_bucket_public_access_block.static_site_public_access_block
  ]

  policy = jsonencode({
    Version = "2012-10-17" # 정책 버전
    Statement = [
      {
        Effect    = "Allow"                              # 허용 정책
        Principal = "*"                                  # 모든 사용자에게 적용
        Action    = "s3:GetObject"                       # S3 오브젝트 읽기 허용
        Resource  = "${aws_s3_bucket.static_site.arn}/*" # 버킷 내 모든 오브젝트에 대한 접근 권한
      }
    ]
  })
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.static_site.id
  key          = var.index_document
  source       = var.index_document_path
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.static_site.id
  key          = var.error_document
  source       = var.error_document_path
  content_type = "text/html"
}
