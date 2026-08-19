output "user_name" {
  description = "IAM 유저명"
  value       = aws_iam_user.example_user.name
}

output "s3_read_role_arn" {
  description = "S3 읽기 가능한 역할 ARN"
  value       = aws_iam_role.s3_read_role.arn
}

output "user_access_key_id" {
  description = "IAM 유저 Access Key ID"
  value       = aws_iam_access_key.example_user_key.id
}

output "user_secret_access_key" {
  description = "IAM 유저 Secret Access Key"
  value       = aws_iam_access_key.example_user_key.secret
  sensitive   = true
}
