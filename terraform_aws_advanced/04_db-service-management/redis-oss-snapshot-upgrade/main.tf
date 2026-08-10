# VPC 모듈
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.21.0"

  # VPC 이름 및 CIDR 범위 설정
  name            = "example-vpc"
  cidr            = var.vpc_cidr
  azs             = ["${var.aws_region}a", "${var.aws_region}b"] # 가용 영역
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]               # 퍼블릭 서브넷 CIDR
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]               # 프라이빗 서브넷 CIDR

  enable_dns_hostnames = true # DNS 호스트 이름 활성화
  enable_dns_support   = true # DNS 지원 활성화

  # IGW 및 라우팅 테이블 자동 생성
  create_igw = true

  # NAT 게이트웨이 단일 사용 설정
  # enable_nat_gateway = true
  # single_nat_gateway = true

  public_subnet_tags = {
    Name = "example-public-subnet" # 퍼블릭 서브넷에 이름 태그 추가
  }

  tags = {
    Name = "example-vpc" # VPC에 이름 태그 추가
  }
}

# Redis 모듈
module "redis" {
  source = "./modules/redis"

  vpc_id               = module.vpc.vpc_id
  private_subnet_ids   = module.vpc.private_subnets
  project_name         = var.project_name
  allowed_cidr_blocks  = var.redis_allowed_cidr_blocks
  node_type            = var.redis_node_type
  num_cache_nodes      = var.redis_num_cache_nodes
  parameter_group_name = var.redis_parameter_group_name
  redis_auth_token     = var.redis_auth_token
}
