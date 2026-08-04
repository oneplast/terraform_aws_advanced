resource "aws_instance" "ec2_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  key_name                    = aws_key_pair.ec2_key_pair.key_name
  associate_public_ip_address = true # Public IP 할ㄷ랑

  tags = {
    Name = var.instance_name
  }
}

resource "random_integer" "random_number" {
  min = 1000
  max = 9999
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "ec2-keypair-${random_integer.random_number.result}"
  public_key = file(pathexpand(var.public_key_path))
}

resource "aws_security_group" "ec2_sg" {
  vpc_id      = var.vpc_id
  name_prefix = "ec2-public-sg-"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
