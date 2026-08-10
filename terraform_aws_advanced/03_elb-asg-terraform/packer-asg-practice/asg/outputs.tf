output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "프라이빗 서브넷 IDs"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "퍼블릭 서브넷 IDs"
  value       = module.vpc.public_subnets
}

output "autoscaling_group_name" {
  description = "ASG 이름"
  value       = aws_autoscaling_group.asg.name
}

output "alb_dns_name" {
  description = "ALB DNS 이름"
  value       = aws_lb.lb.dns_name
}
