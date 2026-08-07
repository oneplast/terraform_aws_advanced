# AWS
aws_region  = "us-east-1"
aws_profile = "my-profile"
environment = "Production"

# VPC
vpc_name           = "my-vpc"
vpc_cidr           = "10.0.0.0/16"
public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets    = ["10.0.3.0/24", "10.0.4.0/24"]
availability_zones = ["us-east-1a", "us-east-1b"]

# EC2
instance_type   = "t2.micro"
instance_name   = "db_client"
public_key_path = "~/.ssh/my-key.pub"

# RDS
# Aurora 클러스터 식별자
cluster_identifier = "my-aurora-cluster"

# Aurora 엔진 버전
db_engine_version = "8.0.mysql_aurora.3.10.1"
# db_engine_version = "8.0.mysql_aurora.3.11.1"
# db_engine_version = "8.0.mysql_aurora.3.12.0"

db_username = "admin"
db_password = "password1234!"

# Aurora 인스턴스 클래스
db_instance_class = "db.r5.xlarge"
# db_instance_class = "db.r5.large"

# 접근 허용 CIDR
allowed_cidr = "10.0.0.0/16"
