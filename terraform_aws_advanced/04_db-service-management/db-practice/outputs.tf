output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "dynamodb_table_name" {
  description = "DynamoDB 테이블명"
  value       = module.dynamodb.dynamodb_table_name
}

output "redis_cluster_endpoint" {
  description = "Redis 클러스터 엔드포인트"
  value       = module.redis.redis_cluster_endpoint
}

output "ec2_instance_id" {
  description = "EC2 인스턴스 ID"
  value       = module.ec2.ec2_instance_id
}

output "ec2_instance_private_ip" {
  description = "EC2 인스턴스 프라이빗 IP"
  value       = module.ec2.ec2_instance_private_ip
}

output "ec2_instance_public_ip" {
  description = "EC2 인스턴스 퍼블릭 IP"
  value       = module.ec2.ec2_instance_public_ip
}
