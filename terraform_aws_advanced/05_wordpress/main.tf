# VPC 모듈 생성
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.21.0"

  name             = "example-vpc"
  cidr             = var.vpc_cidr
  azs              = ["${var.aws_region}a", "${var.aws_region}b"]
  public_subnets   = var.vpc_public_subnets_cidrs  # 퍼블릭 서브넷 CIDR
  private_subnets  = var.vpc_private_subnets_cidrs # ASG 서브넷 CIDR
  database_subnets = var.vpc_db_subnets_cidrs      # RDS 서브넷 CIDR

  enable_dns_hostnames = true # DNS 호스트 이름 활성화
  enable_dns_support   = true # DNS 지원 활성화

  create_igw = true

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    Name = "wordpress-elb-subnet"
  }

  private_subnet_tags = {
    Name = "wordpress-asg-subnet"
  }

  database_subnet_tags = {
    Name = "wordpress-rds-subnet"
  }

  tags = {
    Name = "wordpress-vpc"
  }
}

resource "aws_db_subnet_group" "wordpress_rds_subnet_group" {
  name       = "wordpress-rds-subnet-group"
  subnet_ids = module.vpc.database_subnets

  tags = {
    Name = "WordPress DB subnet group"
  }
}

resource "aws_security_group" "rds_mysql_sg" {
  name   = "rds-mysql-security-group"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = concat(module.vpc.public_subnets_cidr_blocks, module.vpc.private_subnets_cidr_blocks) # VPC의 CIDR 블록을 변수로 호출
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-mysql-sg"
  }
}

resource "aws_db_instance" "wordpress" {
  identifier           = "wordpressdb"
  allocated_storage    = var.db_storage
  storage_type         = var.db_storage_type
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  instance_class       = var.db_instance_class
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = var.db_parameter_group_name
  db_subnet_group_name = aws_db_subnet_group.wordpress_rds_subnet_group.name

  skip_final_snapshot = true
  multi_az            = true

  vpc_security_group_ids = [aws_security_group.rds_mysql_sg.id]
}

resource "aws_efs_file_system" "wordpress_efs" {
  creation_token = "wordpress-efs"

  tags = {
    Name = "WordPress EFS"
  }
}

resource "aws_security_group" "efs_sg" {
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = concat(module.vpc.public_subnets_cidr_blocks, module.vpc.private_subnets_cidr_blocks) # VPC의 CIDR 블록을 변수로 호출
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "efs-security-group"
  }
}

resource "aws_efs_mount_target" "efs_mount" {
  count           = 2
  file_system_id  = aws_efs_file_system.wordpress_efs.id
  subnet_id       = module.vpc.database_subnets[count.index]
  security_groups = [aws_security_group.efs_sg.id]
}

# 빌더 실행
resource "null_resource" "packer_build" {
  provisioner "local-exec" {
    command = <<-EOT
      packer build -var subnet_id=${module.vpc.public_subnets[0]} -var db_username=${var.db_username} -var db_password=${var.db_password} -var efs_domain=${aws_efs_file_system.wordpress_efs.dns_name} -var rds_domain=${aws_db_instance.wordpress.address} al2023-wp-ami.pkr.hcl
    EOT
  }

  // Packer 수정 후 build 할 시, 주석 해제
  # triggers = {
  #   always_run = "${timestamp()}"
  # }

  depends_on = [aws_efs_file_system.wordpress_efs, aws_db_instance.wordpress]
}
