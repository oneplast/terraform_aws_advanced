output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.this.id
}

output "public_subnets" {
  description = "Public Subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnets" {
  description = "Private Subnet IDs"
  value       = aws_subnet.private[*].id
}
