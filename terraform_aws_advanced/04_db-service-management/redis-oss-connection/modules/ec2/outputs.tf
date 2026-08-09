output "ec2_instance_id" {
  description = "EC2 인스턴스 ID"
  value       = aws_instance.ec2_instance.id
}

output "ec2_instance_private_ip" {
  description = "EC2 인스턴스 프라이빗 IP"
  value       = aws_instance.ec2_instance.private_ip
}

output "ec2_instance_public_ip" {
  description = "EC2 인스턴스 퍼블릭 IP"
  value       = aws_instance.ec2_instance.public_ip
}

output "ec2_security_group_id" {
  description = "EC2 보안그룹 ID"
  value       = aws_security_group.ec2_sg.id
}
