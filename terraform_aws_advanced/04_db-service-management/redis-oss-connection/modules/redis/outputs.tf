output "redis_cluster_id" {
  description = "생성된 Redis 클러스터의 고유 ID"
  value       = aws_elasticache_replication_group.redis_cluster.id
}

output "redis_cluster_endpoint" {
  description = "생성된 Redis 클러스터의 Primary 엔드포인트 주소 (읽기/쓰기에 사용)"
  value       = aws_elasticache_replication_group.redis_cluster.primary_endpoint_address
}

output "redis_security_group_id" {
  description = "생성된 Redis 클러스터의 보안 그룹 ID"
  value       = aws_security_group.redis_sg.id
}
