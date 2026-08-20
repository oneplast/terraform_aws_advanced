output "ec2_user_name" {
  description = "EC2 IAM 유저 이름"
  value       = aws_iam_user.project_member.name
}

output "s3_project_data_rw_arn" {
  description = "S3 읽기/쓰기 허용 권한 정책 ARN"
  value       = aws_iam_policy.ec2_s3_policy.arn
}

output "ec2_user_access_key" {
  description = "EC2 IAM 계정 Access Key ID"
  value       = aws_iam_access_key.ec2_user_access_key.id
}

output "ec2_user_secret_key" {
  description = "EC2 IAM 계정 Secret Access Key"
  value       = aws_iam_access_key.ec2_user_access_key.secret
  sensitive   = true
}
