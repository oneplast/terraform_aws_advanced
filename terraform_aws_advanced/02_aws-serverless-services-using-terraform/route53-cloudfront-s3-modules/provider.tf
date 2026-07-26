terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.73.0"
    }
  }
  required_version = ">= 1.9.6"
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}
