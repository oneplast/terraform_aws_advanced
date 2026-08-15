module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.21.0"

  name                = "${var.project_name}-vpc"
  azs                 = ["${var.aws_region}a", "${var.aws_region}b"]
  cidr                = var.vpc_cidr
  public_subnets      = var.public_subnet_cidrs
  private_subnets     = var.private_subnet_cidrs
  database_subnets    = var.db_subnet_cidrs
  elasticache_subnets = var.cache_subnet_cidrs

  enable_dns_hostnames = true
  enable_dns_support   = true

  create_igw = true

  # NAT 게이트웨이 사용 시 주석 해제
  # enable_nat_gateway = true
  # single_nat_gateway = true

  public_subnet_tags = {
    Name = "${var.project_name}-public-subnets"
  }

  private_subnet_tags = {
    Name = "${var.project_name}-private-subnets"
  }

  database_subnet_tags = {
    Name = "${var.project_name}-db-subnets"
  }

  elasticache_subnet_tags = {
    Name = "${var.project_name}-cache-subnets"
  }

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

module "dynamodb" {
  source = "./modules/dynamodb"

  table_name           = var.dynamodb_table_name
  hash_key             = var.dynamodb_hash_key
  hash_key_type        = var.dynamodb_hash_key_type
  range_key            = var.dynamodb_range_key
  range_key_type       = var.dynamodb_range_key_type
  billing_mode         = var.dynamodb_billing_mode
  read_capacity        = var.dynamodb_read_capacity
  write_capacity       = var.dynamodb_write_capacity
  private_subnet_cidrs = var.private_subnet_cidrs
  aws_region           = var.aws_region
  project_name         = var.project_name

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets
}

module "redis" {
  source = "./modules/redis"

  project_name         = var.project_name
  allowed_cidr_blocks  = var.redis_allowed_cidrs
  node_type            = var.redis_node_type
  num_of_node_group    = var.redis_num_cache_nodes
  parameter_group_name = var.redis_parameter_group_name
  redis_auth_token     = var.redis_auth_token

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets
}

module "ec2" {
  source = "./modules/ec2"

  vpc_id               = module.vpc.vpc_id
  ami_id               = data.aws_ami.al2023.id
  subnet_id            = module.vpc.public_subnets[0]
  instance_type        = var.ec2_instance_type
  public_key_path      = var.ec2_public_key_path
  project_name         = var.project_name
  public_cidrs         = [var.public_cidr]
  redis_cidrs          = var.redis_allowed_cidrs
  user_data            = var.ec2_user_data
  ec2_instance_profile = module.dynamodb.ec2_instance_profile
}

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}
