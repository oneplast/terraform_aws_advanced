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

# RDS
# RDS 접근 허용 CIDR
allowed_cidr = "10.0.0.0/16"

# RDS 인스턴스 설정
db_engine_version  = "8.0"
db_instance_class  = "db.r5.large" # 사용하려는 인스턴스 타입
cluster_identifier = "my-rds-restored"

# RDS 보안 설정
db_username = "admin"
db_password = "securepassword123!"

db_cluster_snapshot_identifier = "tf-snapshot-{...}" # 스냅샷 이름

# EC2
instance_type   = "t2.micro"
instance_name   = "db_client"
public_key_path = "~/.ssh/my-key.pub"
