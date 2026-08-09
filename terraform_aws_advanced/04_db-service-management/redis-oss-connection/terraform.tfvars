# AWS
aws_region  = "us-east-1"
aws_profile = "my-profile"

# VPC
vpc_cidr             = "10.0.0.0/16"
private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
public_subnet_cidrs  = ["10.0.3.0/24", "10.0.4.0/24"]
availability_zones   = ["a", "b"]
project_name         = "my-project"

# EIP
# elastic_ips = ["eipalloc-12345678", "eipalloc-87654321"]

# DynamoDb
dynamodb_table_name    = "my-dynamodb-table"
dynamodb_hash_key      = "id"
dynamodb_hash_key_type = "S"
dynamodb_billing_mode  = "PAY_PER_REQUEST"

# Redis
redis_allowed_cidr_blocks = ["10.0.0.0/16"]
redis_auth_token          = "YourStrongAuthPassword123!"

# EC2
ec2_ami_id                  = "" # 내 EC2 AMI ID
ec2_instance_type           = "t2.micro"
ec2_public_key_path         = "~/.ssh/my-key.pub"
ec2_allowed_ssh_cidr_blocks = ["0.0.0.0/0"]
