output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "redis_cluster_endpoint" {
  description = "Redis 클러스터 엔드포인트"
  value       = module.redis.redis_cluster_endpoint
}
