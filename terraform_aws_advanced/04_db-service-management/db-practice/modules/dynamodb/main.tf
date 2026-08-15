resource "aws_dynamodb_table" "main_table" {
  billing_mode   = var.billing_mode
  name           = var.table_name
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity
  hash_key       = var.hash_key

  attribute {
    name = var.hash_key
    type = var.hash_key_type
  }

  # Range Key가 있는 경우 추가
  dynamic "attribute" {
    for_each = var.range_key != null ? [var.range_key] : []
    content {
      name = var.range_key
      type = var.range_key_type
    }
  }

  range_key = var.range_key != null ? var.range_key : null

  tags = {
    Name = "${var.project_name}-dynamodb"
  }
}

resource "aws_security_group" "dynamodb_sg" {
  name   = "${var.project_name}-dynamodb-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-dynamodb-sg"
  }
}

# DynamoDB 접근용 VPC 엔드포인트
resource "aws_vpc_endpoint" "dynamodb_endpoint" {
  vpc_id             = var.vpc_id
  service_name       = "com.amazonaws.${var.aws_region}.dynamodb"
  subnet_ids         = var.private_subnet_ids
  security_group_ids = [aws_security_group.dynamodb_sg.id]

  vpc_endpoint_type = "Interface"

  tags = {
    Name = "${var.project_name}-dynmoadb-endpoint"
  }
}

resource "aws_iam_role" "ec2_dynamodb_role" {
  name = "EC2DynamoDBRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "dynamodb_access_policy" {
  name = "DynamoDBFullAccessPolicy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "dynamodb:*" # 모든 DynamoDB 작업 허용
      ]
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_dynamodb_policy_attachment" {
  role       = aws_iam_role.ec2_dynamodb_role.name
  policy_arn = aws_iam_policy.dynamodb_access_policy.arn
}

# 인스턴스 프로파일 생성
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "EC2DynamoDBInstanceProfile"
  role = aws_iam_role.ec2_dynamodb_role.name
}
