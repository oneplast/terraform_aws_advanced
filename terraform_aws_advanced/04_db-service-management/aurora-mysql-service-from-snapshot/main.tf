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
  instance_name   = var.instance_name
  vpc_id          = module.vpc.vpc_id
  subnet_id       = module.vpc.public_subnets[0]
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
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.vpc_name}-db-subnet-group-restore"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name = "${var.vpc_name}-db-subnet-group"
  }
}

# Aurora 클러스터 생성
resource "aws_rds_cluster" "my_aurora_cluster" {
  cluster_identifier     = var.cluster_identifier
  snapshot_identifier    = var.db_cluster_snapshot_identifier
  engine                 = "aurora-mysql"
  engine_version         = var.db_engine_version
  master_username        = var.db_username
  master_password        = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  skip_final_snapshot     = true
  backup_retention_period = 7             # 백업 보존 기간 (일)
  preferred_backup_window = "07:00-09:00" # 백업 원하는 시간

  tags = {
    Name        = "My-Aurora-Cluster"
    Environment = var.environment
  }
}

# Aurora 클러스터 인스턴스 생성
resource "aws_rds_cluster_instance" "my_aurora_instance" {
  cluster_identifier   = aws_rds_cluster.my_aurora_cluster.id
  instance_class       = var.db_instance_class
  engine               = "aurora-mysql"
  db_subnet_group_name = aws_db_subnet_group.this.name
  publicly_accessible  = false # 퍼블릭 액세스 설정

  tags = {
    Name        = "My-Aurora-Instance"
    Environment = var.environment
  }
}
