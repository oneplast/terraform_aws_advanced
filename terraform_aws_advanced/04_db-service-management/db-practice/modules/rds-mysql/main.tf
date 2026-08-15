resource "aws_security_group" "rds_sg" {
  name   = "rds-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.rds_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.db_name}-subnet-group" # DB 서브넷 그룹 이름
  subnet_ids = var.private_subnet_ids        # 프라이빗 서브넷 ID 목록

  tags = {
    Name = "${var.db_name}-subnet-group"
  }
}

resource "aws_db_instance" "rds_instance" {
  allocated_storage      = var.rds_storage                           # RDS 인스턴스 스토리지 크기 (GiB)
  apply_immediately      = true                                      # 업데이트 즉시 적용
  engine_version         = var.engine_version                        # DB 엔진 버전
  engine                 = "mysql"                                   # DB 엔진 (MySQL)
  deletion_protection    = false                                     # 삭제 방지 Off
  instance_class         = var.instance_class                        # RDS 인스턴스 유형
  parameter_group_name   = var.db_parameter_group                    # RDS 파라미터 그룹
  db_name                = var.db_name                               # DB 이름
  username               = var.db_username                           # 관리자 계정 이름
  password               = var.db_password                           # 관리자 계정 비밀번호
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name # DB 서브넷 그룹 이름
  publicly_accessible    = false                                     # 퍼블릭 접근 비활성화
  multi_az               = var.db_multi_az                           # 다중 가용 영역 배포 여부
  vpc_security_group_ids = [aws_security_group.rds_sg.id]            # 적용할 보안 그룹 ID

  skip_final_snapshot = true # 삭제 시 최종 스냅샷 비생성

  # 백업 관련 설정
  backup_retention_period = 7             # 백업 보존 기간 (일 단위)
  backup_window           = "02:00-03:00" # 백업 시작 시간 (UTC 기준)

  # 모니터링 및 유지관리
  maintenance_window = "sun:05:00-sun:06:00" # 유지보수 시간 (UTC 기준)

  # 스토리지 및 암호화 설정
  storage_type = var.rds_storage_type # 스토리지 유형 (현재 변수 gp2: 범용 SSD)
  # storage_encrypted = true

  tags = {
    Name = "RDS-MySQL"
  }
}

resource "aws_db_instance" "rds_read_replica" {
  engine              = "mysql"            # DB 엔진
  instance_class      = var.instance_class # 인스턴스 유형
  publicly_accessible = false              # 퍼블릭 접근 비활성화
  skip_final_snapshot = ture               # 최종 스냅샷 비생성

  replicate_source_db = aws_db_instance.rds_instance.identifier # 복제할 원본 인스턴스 ID

  tags = {
    Name = "RDS-Read-Replica"
  }
}
