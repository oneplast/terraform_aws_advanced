# Redis ElastiCache 서브넷 그룹
resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "${var.project_name}-redis-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.project_name}-redis-subnet-group"
  }
}

# Redis 보안 그룹
resource "aws_security_group" "redis_sg" {
  name        = "${var.project_name}-redis-sg"
  description = "Redis 보안 그룹"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-redis-sg"
  }
}

# Redis ElastiCache 클러스터
resource "aws_elasticache_replication_group" "redis_cluster" {
  replication_group_id = "${var.project_name}-redis"
  description          = "Redis Replication Group"
  engine               = "redis"
  node_type            = var.node_type
  num_cache_clusters   = var.num_cache_nodes
  parameter_group_name = var.parameter_group_name
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids   = [aws_security_group.redis_sg.id]

  # 유지보수 및 스냅샷 시간 설정
  maintenance_window       = "tue:06:30-tue:07:30"
  snapshot_window          = "01:00-02:00" # 스냅샷 시간
  snapshot_retention_limit = 7             # 오늘 만든 스냅샷은 삭제되기 전에 7일 동안 보존
  # snapshot_name            = "my-redis-snapshot" # 복원하는 경우, 복원할 스냅샷을 지정 (변경하면 강제로 재생성됨)

  # 즉시 적용 설정
  apply_immediately = true

  # Enable encryption in transit (TLS)
  transit_encryption_enabled = true

  # Optional: Enable encryption at rest
  at_rest_encryption_enabled = true

  auth_token                 = "YourStrongAuthPassword123!"
  auth_token_update_strategy = "SET"

  tags = {
    Name = "${var.project_name}-redis-cluster"
  }
}
