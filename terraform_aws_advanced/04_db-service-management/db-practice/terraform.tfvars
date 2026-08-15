# AWS
aws_region  = "us-east-1"
aws_profile = "my-profile"

# Public
public_cidr  = "0.0.0.0/0"
project_name = "my-project"

# VPC
vpc_cidr             = "10.0.0.0/16"
availability_zones   = ["a", "b"]
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
db_subnet_cidrs      = ["10.0.5.0/24", "10.0.6.0/24"]
cache_subnet_cidrs   = ["10.0.7.0/24", "10.0.8.0/24"]

# DynamoDB
dynamodb_table_name     = "Products"
dynamodb_hash_key       = "product_id"
dynamodb_hash_key_type  = "S"
dynamodb_billing_mode   = "PROVISIONED"
dynamodb_read_capacity  = 5
dynamodb_write_capacity = 5

# Redis
redis_allowed_cidrs        = ["10.0.0.0/16"]
redis_auth_token           = "YourStrongAuthPassword123!"
redis_parameter_group_name = "default.valkey8.cluster.on"

# EC2
ec2_instance_type   = "t2.micro"
ec2_public_key_path = "~/.ssh/my-key.pub"
