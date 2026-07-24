output "vpc_id" {
  description = "VPC의 ID"
  value       = aws_vpc.this.id
}
