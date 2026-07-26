# System
variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "aws_profile" {
  description = "CLI 인증 프로파일"
  type        = string
}

variable "environment" {
  description = "환경 설정"
  type        = string
}

# S3
variable "bucket_name" {
  description = "S3 버킷 이름"
  type        = string
}

variable "index_key" {
  description = "S3 인덱스 키"
  type        = string
}

# Lambda
variable "lambda_function_name" {
  description = "function 이름"
  type        = string
}

variable "lambda_handler" {
  description = "람다 핸들러"
  type        = string
}

variable "lambda_runtime" {
  description = "람다 runtime"
  type        = string
}

variable "lambda_memory_size" {
  description = "람다 메모리 크기"
  type        = number
}

variable "lambda_timeout" {
  description = "람다 타임아웃"
  type        = number
}

# API Gateway
variable "api_name" {
  description = "API Gateway HTTP API 이름"
  type        = string
}

# VPC
variable "vpc_name" {
  description = "VPC 이름"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

# Route 53
variable "route53_zone" {
  description = "Route 53 Hosted Zone 이름"
  type        = string
}

# WAF
variable "waf_name" {
  description = "WAF 이름"
  type        = string
}

# CloudWatch
variable "email" {
  description = "알림 받을 이메일"
  type        = string
}

variable "alarm_name" {
  description = "알람 이름"
  type        = string
}

variable "dashboard_name" {
  description = "CloudWatch 대시보드 이름"
  type        = string
}
