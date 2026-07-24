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

resource "aws_s3_bucket" "terraform_state" {
  bucket = var.s3_bucket_name

  tags = {
    Name        = "TerraformStateBucket"
    Environment = var.environment
  }
}

# S3 버킷 버전 관리 설정
resource "aws_s3_bucket_versioning" "example" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled" # S3 버킷 버전 관리 활성화
  }
}

# S3 버킷 암호화 설정
resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" # 서버 사이드 암호화 알고리즘 설정 (AES256)
    }
  }
}

# DynamoDB 테이블 생성 (잠금 관리를 위한 테이블)
resource "aws_dynamodb_table" "terraform_lock" {
  name         = var.dynamodb_table_name # 잠금 관리를 위한 테이블 이름
  billing_mode = "PAY_PER_REQUEST"       # 사용량 기반 과금 설정
  hash_key     = "LockID"                # 해시 키 설정 (잠금 식별자)

  attribute {
    name = "LockID" # 테이블 해시 키 이름
    type = "S"      # 해시 키 데이터 타입 설정 (문자열)
  }

  tags = {
    Name        = "TerraformStateLockTable"
    Environment = var.environment
  }
}
