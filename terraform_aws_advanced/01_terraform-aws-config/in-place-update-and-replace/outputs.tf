output "ec_domain" {
  value = aws_instance.my_ec2.public_dns
}

output "ec_public_ip" {
  value = aws_instance.my_ec2.public_ip
}
