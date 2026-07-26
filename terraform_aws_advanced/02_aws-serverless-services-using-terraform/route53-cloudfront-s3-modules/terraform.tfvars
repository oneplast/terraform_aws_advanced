# AWS 설정
aws_region  = "us-east-1"
aws_profile = "my-profile"

# S3 버킷 설정
bucket_name = "my-static-site"
environment = "dev"

# S3 웹사이트 설정
index_document      = "index.html"
error_document      = "error.html"
index_document_path = "files/index.html"
error_document_path = "files/error.html"

# Route53 및 EC2 설정
private_dns_name         = "test.private.example.com"
instance_type            = "t2.micro"
pub_key_file_path        = "~/.ssh/my-key.pub"
vpc_name                 = "private-dns-test-vpc"
vpc_cidr_block           = "10.0.0.0/16"
public_subnet_cidr       = "10.0.0.0/24"
subnet_availability_zone = "us-east-1a"
