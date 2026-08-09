output "dynamodb_table_name" {
  description = "DynamoDB 테이블명"
  value       = aws_dynamodb_table.main_table.name
}

output "dynamodb_table_arn" {
  description = "DynamoDB 테이블 ARN"
  value       = aws_dynamodb_table.main_table.arn
}

output "dynamodb_endpoint_id" {
  description = "DynamoDB VPC 엔드포인트 ID"
  value       = aws_vpc_endpoint.dynamodb_endpoint.id
}

output "dynamodb_security_group_id" {
  description = "DynamoDB 보안 그룹 ID"
  value       = aws_security_group.dynamodb_sg.id
}

output "ec2_instance_profile" {
  description = "EC2에 부여할 DynamoDB 접근 프로파일"
  value       = aws_iam_instance_profile.ec2_instance_profile.name
}
