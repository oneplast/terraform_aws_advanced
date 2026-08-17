# AWS
aws_region  = "us-east-1"
aws_profile = "my-profile"

# AMI ID (Packer 이후 생성된 AMI ID로 수정)
ami_id = ""

# VPC
vpc_cidr                  = "10.0.0.0/16"
vpc_public_subnets_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
vpc_private_subnets_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
vpc_db_subnets_cidrs      = ["10.0.5.0/24", "10.0.6.0/24"]

# RDS
db_storage              = 20
db_storage_type         = "gp2"
db_engine               = "mysql"
db_engine_version       = "8.0"
db_instance_class       = "db.t3.micro"
db_name                 = "wordpressdb"
db_username             = "wordpress"
db_password             = "test1234"
db_parameter_group_name = "default.mysql8.0"
