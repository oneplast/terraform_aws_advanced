resource "aws_security_group" "redis-sg" {
  name   = "${var.project_name}-redis-sg"
  vpc_id = var.vpc_id

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

resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "${var.project_name}-redis-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.project_name}-redis-subnet-group"
  }
}

resource "aws_elasticache_replication_group" "redis_cluster" {
  replication_group_id = var.cluster_id
  description          = "레디스 클러스터 (클러스터 모드)"
  engine               = var.engine
  node_type            = var.node_type
  parameter_group_name = var.parameter_group_name
  security_group_ids   = [aws_security_group.redis-sg.id]
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group.name

  # 클러스터 모드 구성 시 필요한 아규먼트
  cluster_mode               = var.cluster_mode
  num_node_groups            = var.num_of_node_group    # 노드 그룹 수 = 샤드 수
  replicas_per_node_group    = var.num_of_replica_nodes # 노드 그룹 당 복제본 수
  automatic_failover_enabled = true

  # Enable encryption in transit (TLS)
  transit_encryption_enabled = true

  # Optional: Enable encryption at rest
  at_rest_encryption_enabled = true

  auth_token                 = var.redis_auth_token
  auth_token_update_strategy = "SET"

  tags = {
    Name = "${var.project_name}-redis-cluster"
  }
}
