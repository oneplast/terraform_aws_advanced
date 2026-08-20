# IAM 유저 생성
resource "aws_iam_user" "project_member" {
  name          = var.iam_user_name
  path          = "/"
  force_destroy = false
}

# S3 읽기/쓰기 정책 생성
resource "aws_iam_policy" "ec2_s3_policy" {
  name = "S3ReadWritePolicy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject", # S3 객체 읽기 권한
          "s3:PutObject"  # S3 객체 쓰기 권한
        ]
        Resource = "arn:aws:s3:::${var.s3_bucket_name}/*" # 대상 S3 버킷과 모든 객체
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "ec2_user_s3_attach" {
  user       = aws_iam_user.project_member.name
  policy_arn = aws_iam_policy.ec2_s3_policy.arn
}

# 생성한 유저에 대한 Access Key 생성 (프로그래밍적 접근을 위해 사용)
resource "aws_iam_access_key" "ec2_user_access_key" {
  user = aws_iam_user.project_member.name
}
