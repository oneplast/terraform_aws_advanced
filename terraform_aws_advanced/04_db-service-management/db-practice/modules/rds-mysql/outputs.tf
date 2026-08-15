output "rds_endpoint" {
  description = "RDS 엔드포인트"
  value       = aws_db_instance.rds_instance.endpoint
}

output "rds_read_replica_endpoint" {
  description = "RDS Replica 엔드포인트 (읽기 전용)"
  value       = aws_db_instance.rds_read_replica.endpoint
}

output "rds_security_group_id" {
  description = "RDS 보안 그룹 ID"
  value       = aws_security_group.rds_sg.id
}
