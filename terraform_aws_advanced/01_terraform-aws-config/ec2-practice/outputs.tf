output "ec2_instance_name" {
  value = aws_instance.ec2[*].id
}

output "ec2_public_ips" {
  value = [
    for instance in aws_instance.ec2 : instance.public_ip
  ]
}

output "ec2_public_dns" {
  value = aws_instance.ec2[*].public_dns
}
