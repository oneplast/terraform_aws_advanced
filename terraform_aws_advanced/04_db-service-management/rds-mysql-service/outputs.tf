output "rds_endpoint" {
  description = "RDS 인스턴스 엔드포인트"
  value       = aws_db_instance.my_rds_instance.endpoint
}

output "rds_endpoint_read_replica" {
  description = "읽기 전용 RDS 인스턴스 엔드포인트"
  value       = aws_db_instance.read_replica.endpoint
}

output "rds_security_group_id" {
  description = "RDS 보안 그룹 ID"
  value       = aws_security_group.rds_sg.id
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "퍼블릭 서브넷 IDs"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "프라이빗 서브넷 IDs"
  value       = module.vpc.private_subnets
}

output "public_dns" {
  description = "EC2 인스턴스 퍼블릭 DNS"
  value       = module.ec2.public_dns
}
