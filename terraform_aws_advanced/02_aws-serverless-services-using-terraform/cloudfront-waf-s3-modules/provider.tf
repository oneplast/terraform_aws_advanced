terraform {
  required_version = ">= 1.9.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.73.0"
    }
  }
}

# AWS 프로바이더 설정
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}
