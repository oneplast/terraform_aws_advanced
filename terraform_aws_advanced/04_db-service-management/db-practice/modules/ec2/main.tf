resource "random_string" "key_name_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_key_pair" "public_key_pair" {
  key_name   = "public-key-${random_string.key_name_suffix.result}"
  public_key = file(pathexpand(var.public_key_path))

  tags = {
    Name = "public-key-${random_string.key_name_suffix.result}"
  }
}

resource "aws_security_group" "ec2_sg" {
  name   = "${var.project_name}-ec2-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.public_cidrs
  }

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = var.redis_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.public_cidrs
  }

  tags = {
    Name = "${var.project_name}-ec2-sg"
  }
}

resource "aws_instance" "ec2" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true

  key_name = aws_key_pair.public_key_pair.key_name

  iam_instance_profile = var.ec2_instance_profile

  user_data = var.user_data

  tags = {
    Name = "${var.project_name}-ec2-instance"
  }
}
