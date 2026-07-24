output "vpc_id" {
  description = "생성된 VPC의 ID"
  value       = aws_vpc.my_vpc.id
}

output "public_subnet_id" {
  description = "생성된 퍼블릭 서브넷의 ID"
  value       = aws_subnet.public_subnet.id
}

output "internet_gateway_id" {
  description = "생성된 인터넷 게이트웨이의 ID"
  value       = aws_internet_gateway.my_igw.id
}

output "route_table_id" {
  description = "생성된 라우팅 테이블의 ID"
  value       = aws_route_table.public_route_table.id
}

output "security_group_id" {
  description = "생성된 보안 그룹의 ID"
  value       = aws_security_group.my_sg.id
}

output "ec2_instance_id" {
  description = "생성된 EC2 인스턴스의 ID"
  value       = aws_instance.my_ec2.id
}

output "ec2_instance_public_ip" {
  description = "EC2 인스턴스의 퍼블릭 IP 주소"
  value       = aws_instance.my_ec2.public_ip
}

output "ec2_domain" {
  value = aws_instance.my_ec2.public_dns
}
