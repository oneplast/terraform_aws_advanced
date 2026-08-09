resource "aws_security_group" "ec2_sg" {
  name        = "${var.project_name}-ec2-sg"
  description = "EC2 인스턴스 보안 그룹"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr_blocks
  }

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = var.redis_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-ec2-sg"
  }
}


resource "random_string" "key_name_prefix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_key_pair" "my_key_pair" {
  key_name   = "my-key-${random_string.key_name_prefix.result}"
  public_key = file(pathexpand(var.public_key_path))

  tags = {
    Name = "MyKeyPair-${random_string.key_name_prefix.result}"
  }
}

resource "aws_instance" "ec2_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  key_name                    = aws_key_pair.my_key_pair.key_name
  associate_public_ip_address = true

  iam_instance_profile = var.ec2_instance_profile

  # Optionally add user data for bootstrapping
  user_data = var.user_data

  tags = {
    Name = "${var.project_name}-ec2-instance"
  }
}
