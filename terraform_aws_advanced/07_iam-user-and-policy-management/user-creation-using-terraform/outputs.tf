output "ec2_user_name" {
  description = "생성된 IAM 유저의 이름 출력"
  value       = aws_iam_user.ec2_user.name
}

output "ec2_group_name" {
  description = "생성된 IAM 그룹의 이름 출력"
  value       = aws_iam_group.ec2_managers.name
}

output "ec2_user_access_key_id" {
  description = "IAM 유저 Access Key ID 출력"
  value       = aws_iam_access_key.ec2_user_key.id
}

output "ec2_user_secret_access_key" {
  description = "IAM 유저 Secret Access Key 출력"
  value       = aws_iam_access_key.ec2_user_key.secret
  sensitive   = true # 민감 정보로 표시
}
