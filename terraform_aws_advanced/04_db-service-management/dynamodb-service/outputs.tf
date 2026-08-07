output "dynamodb_table_name" {
  description = "DynamoDB 테이블명"
  value       = aws_dynamodb_table.users_table.name
}

output "dynamodb_table_arn" {
  description = "DynamoDB 테이블 ARN"
  value       = aws_dynamodb_table.users_table.arn
}
