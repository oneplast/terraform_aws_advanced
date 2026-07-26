output "key_pair_name" {
  description = "The name of the generated key pair."
  value       = aws_key_pair.generated_key_pair.key_name
}

output "ec2_public_ip" {
  description = "The public IP address of the EC2 instance."
  value       = aws_instance.dns_test_instance.public_ip
}

output "ec2_public_dns" {
  description = "The public DNS of the EC2 instance."
  value       = aws_instance.dns_test_instance.public_dns
}

output "private_dns_zone_id" {
  description = "The ID of the created private DNS hosted zone."
  value       = aws_route53_zone.private_dns.zone_id
}
