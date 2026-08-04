output "instance_id" {
  description = "EC2 인스턴스 ID"
  value       = aws_instance.ec2_instance.id
}

output "public_ip" {
  description = "EC2 퍼블릭 IP"
  value       = aws_instance.ec2_instance.public_ip
}

output "public_dns" {
  description = "EC2 퍼블릭 DNS"
  value       = aws_instance.ec2_instance.public_dns
}
