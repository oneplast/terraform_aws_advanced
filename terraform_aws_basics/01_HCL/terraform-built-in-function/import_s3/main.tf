
terraform {
  required_version = ">=1.9.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.73.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "my-profile"
}

resource "aws_s3_bucket" "example" {
  bucket = "oneplast-bucket-20260704"
}

import {
  to = aws_s3_bucket.example
  id = "oneplast-bucket-20260704"
}
