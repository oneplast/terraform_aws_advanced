# 운영용 IAM 계정
resource "aws_iam_user" "prod_user" {
  name          = var.prod_user_name
  path          = "/"
  force_destroy = false
}

# EC2 상태 조회를 위한 IAM 역할 생성
resource "aws_iam_role" "dev_ec2_status_view_role" {
  name = var.dev_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "${aws_iam_user.prod_user.arn}" # 역할을 사용할 계정 ARN
        }
        Action = "sts:AssumeRole" # sts:AssumeRole 액션 허용
      }
    ]
  })
}

# EC2 인스턴스 상태 조회 권한 정책 생성
resource "aws_iam_policy" "ec2_status_view_policy" {
  name = var.ec2_view_status_role_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "ec2:DescribeInstances" # EC2 인스턴스 상태 조회
        Resource = "*"                     # 모든 리소스에 대해 적용
      }
    ]
  })
}

# EC2 상태 조회 역할에 정책 연결
resource "aws_iam_role_policy_attachment" "dev_ec2_status_view_attach" {
  role       = aws_iam_role.dev_ec2_status_view_role.name # 역할 이름
  policy_arn = aws_iam_policy.ec2_status_view_policy.arn  # 정책 ARN
}
