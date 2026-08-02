output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "Private Subnets IDs"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "Public Subnets IDs"
  value       = module.vpc.public_subnets
}

# 오토 스케일링 그룹 이름 출력
output "autoscaling_group_name" {
  description = "오토 스케일링 그룹 이름"
  value       = aws_autoscaling_group.example.name
}

# 애플리케이션 로드 밸런서 DNS 이름 출력
output "alb_dns_name" {
  description = "애플리케이션 로드 밸런서 DNS 이름"
  value       = aws_lb.example.dns_name
}
