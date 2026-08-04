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

########
# RDS
########
allowed_cidr = "10.0.0.0/16" # 접근 허용 CIDR

# RDS 인스턴스 설정
db_allocated_storage = 20
db_engine_version    = "8.0"
db_instance_class    = "db.t3.micro"
db_name              = "mydatabase"

# RDS 보안 설정
db_username = "admin"
db_password = "securepassword123!" # 민감 정보, 환경 변수로도 관리 가능

db_parameter_group_name = "default.mysql8.0" # DB 파라미터 그룹
db_multi_az             = true               # RDS 멀티 AZ 설정

# EC2
instance_type   = "t2.micro"
instance_name   = "db_client"
public_key_path = "~/.ssh/my-key.pub"
