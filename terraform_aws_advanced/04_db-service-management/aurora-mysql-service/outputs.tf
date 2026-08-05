output "aurora_cluster_endpoint" {
  description = "Aurora 클러스터 엔드포인트 (읽기/쓰기)"
  value       = aws_rds_cluster.my_aurora_cluster.endpoint
}

output "aurora_cluster_port" {
  description = "Aurora 클러스터 포트"
  value       = aws_rds_cluster.my_aurora_cluster.port
}

output "aurora_cluster_reader_endpoint" {
  description = "Aurora 클러스터 읽기 전용 엔드포인트"
  value       = aws_rds_cluster.my_aurora_cluster.reader_endpoint
}

output "aurora_instance_id" {
  description = "Aurora 인스턴스 ID"
  value       = aws_rds_cluster_instance.my_aurora_instance[*].id
}

output "aurora_cluster_arn" {
  description = "Aurora 클러스터 ARN (Amazon Resource Name)"
  value       = aws_rds_cluster.my_aurora_cluster.arn
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "퍼블릭 서브넷 IDs"
  value       = module.vpc.public_subnets
}

output "priavte_subnets" {
  description = "프라이빗 서브넷 IDs"
  value       = module.vpc.private_subnets
}

output "public_dns" {
  description = "EC2 인스턴스 퍼블릭 DNS"
  value       = module.ec2.public_dns
}
