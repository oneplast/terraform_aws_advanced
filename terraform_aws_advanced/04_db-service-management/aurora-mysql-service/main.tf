module "vpc" {
  source = "./modules/vpc"

  vpc_name           = var.vpc_name
  vpc_cidr           = var.vpc_cidr
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zones
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

module "ec2" {
  source = "./modules/ec2"

  ami_id          = data.aws_ami.al2023.id
  instance_type   = var.instance_type
  vpc_id          = module.vpc.vpc_id
  subnet_id       = module.vpc.public_subnets[0]
  instance_name   = var.instance_name
  public_key_path = var.public_key_path
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Allow DB access"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.vpc_name}-db-subnet-group-0" # DB 서브넷 그룹 이름
  subnet_ids = module.vpc.private_subnets          # 프라이빗 서브넷 ID 목록

  tags = {
    Name = "${var.vpc_name}-db-subnet-group"
  }
}

resource "aws_rds_cluster" "my_aurora_cluster" {
  cluster_identifier     = "${var.cluster_identifier}-0"  # 클러스터 ID
  engine                 = "aurora-mysql"                 # 엔진 종류 (MySQL 호환 Aurora)
  engine_version         = var.db_engine_version          # 엔진 버전
  master_username        = var.db_username                # 관리자 계정 이름
  master_password        = var.db_password                # 관리자 계정 비밀번호
  db_subnet_group_name   = aws_db_subnet_group.this.name  # DB 서브넷 그룹 이름
  vpc_security_group_ids = [aws_security_group.rds_sg.id] # VPC 보안 그룹 이름

  skip_final_snapshot          = true                  # 삭제 시 최종 스냅샷 생성 여부
  backup_retention_period      = 7                     # 백업 보존 기간 (일)
  preferred_backup_window      = "07:00-09:00"         # 백업 시간 (UTC 기준)
  apply_immediately            = true                  # 업데이트 즉시 적용
  preferred_maintenance_window = "mon:05:00-mon:07:00" # 유지보수 시간 (UTC) 기준

  # storage_encrypted   = true # 스토리지 암호화 여부
  # deletion_protection = true # 삭제 보호 활성화

  tags = {
    Name        = "My-Aurora-Cluster" # 클러스터 이름 태그
    Environment = var.environment     # 환경 태그
  }
}

resource "aws_rds_cluster_instance" "my_aurora_instance" {
  count                = 1                                    # 쓰기, 읽기, 읽기
  cluster_identifier   = aws_rds_cluster.my_aurora_cluster.id # 클러스터 ID
  instance_class       = var.db_instance_class                # 인스턴스 클래스
  engine               = "aurora-mysql"                       # 엔진 (Aurora MySQL)
  engine_version       = var.db_engine_version                # 엔진 버전
  db_subnet_group_name = aws_db_subnet_group.this.name        # DB 서브넷 그룹 이름
  publicly_accessible  = false                                # 퍼블릭 액세스 비활성화
  apply_immediately    = true                                 # 업데이트 즉시 적용

  # monitoring_interval  = 60                                   # 모니터링 간격 (초)
  # performance_insights_enabled = true # 성능 통찰력 활성화

  tags = {
    Name        = "My-Aurora-Instance${count.index + 1}" # 인스턴스 이름 태그
    Environment = var.environment                        # 환경 태그
  }
}
