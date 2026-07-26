# System
environment = "dev"

# EC2
aws_region  = "us-east-1"
aws_profile = "my-profile"

# S3
bucket_name = "last-lambda-code"
index_key   = "index.zip"

# Lambda
lambda_function_name = "my-serverless-function"
lambda_handler       = "index.handler"
lambda_runtime       = "nodejs22.x"
lambda_memory_size   = 128
lambda_timeout       = 30

# API Gateway
api_name = "serverless-api"

# VPC
vpc_name = "my-vpc"
vpc_cidr = "10.0.0.0/16"

# Route 53
route53_zone = "my-domain.com"

# WAF
waf_name = "serverless-waf"

# CloudWatch
email          = "riverpower6@naver.com"
alarm_name     = "lambda-errors"
dashboard_name = "ServerlessDashboard"
