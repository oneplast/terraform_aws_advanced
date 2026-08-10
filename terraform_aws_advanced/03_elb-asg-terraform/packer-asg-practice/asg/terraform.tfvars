# AWS
aws_region      = "us-east-1"
aws_profile     = "my-profile"
project_name    = "my-project"
public_key_path = "~/.ssh/my-key.pub"
public_cidr     = "0.0.0.0/0"

# VPC
vpc_name            = "my-vpc"
vpc_cidr            = "10.0.0.0/16"
vpc_public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
vpc_private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]

# ASG
asg_desired_capacity = 2
asg_max_capacity     = 3
asg_min_capacity     = 1

# Packer
packer_ami    = "" # 'packer build .' 실행 후, 생성된 AMI 사용
instance_type = "t2.micro"
