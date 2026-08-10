module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.21.0"

  name            = var.vpc_name
  cidr            = var.vpc_cidr
  azs             = ["${var.aws_region}a", "${var.aws_region}b"]
  public_subnets  = var.vpc_public_subnets
  private_subnets = var.vpc_private_subnets

  enable_dns_hostnames = true
  enable_dns_support   = true

  create_igw = true

  # enable_nat_gateway = true # NAT 게이트웨이 필요 시 주석 해제
  # single_nat_gateway = true # 단일 NAT 게이트웨이 필요 시 주석 해제

  public_subnet_tags = {
    Name = "${var.project_name}-${var.vpc_name}-public-subnets"
  }

  tags = {
    Name = "${var.project_name}-${var.vpc_name}"
  }
}

resource "random_integer" "key-suffix" {
  min = 1000
  max = 9999
}

resource "aws_key_pair" "public_key_pair" {
  key_name   = "my-keypair-${random_integer.key-suffix.result}"
  public_key = file(pathexpand(var.public_key_path))
}

resource "aws_launch_template" "launch_template" {
  name_prefix   = "asg-launch-template-"
  image_id      = var.packer_ami
  instance_type = var.instance_type

  key_name = aws_key_pair.public_key_pair.key_name

  # 네트워크 인터페이스 설정 (보안 그룹 포함)
  network_interfaces {
    security_groups             = [aws_security_group.asg_sg.id]
    associate_public_ip_address = true
  }
}

resource "aws_security_group" "asg_sg" {
  name_prefix = "asg-sg-"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.public_cidr]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.public_cidr]
  }

  tags = {
    Name = "${var.project_name}-asg-sg"
  }
}

resource "aws_security_group" "alb_sg" {
  name_prefix = "alb-sg-"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.public_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.public_cidr]
  }

  tags = {
    Name = "${var.project_name}-alb-sg"
  }
}

resource "aws_autoscaling_group" "asg" {
  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  # EC2 인스턴스 상태 확인 방식
  health_check_type         = "EC2" # EC2 상태 확인 방식 사용
  health_check_grace_period = 300   # 인스턴스 상태 확인 대기 시간

  vpc_zone_identifier = module.vpc.public_subnets
  desired_capacity    = var.asg_desired_capacity
  max_size            = var.asg_max_capacity
  min_size            = var.asg_min_capacity
}

resource "aws_lb" "lb" {
  name     = "aws-lb"
  internal = false # 외부 접근 가능

  load_balancer_type = "application"                  # ALB 유형
  subnets            = module.vpc.public_subnets      # 퍼블릭 서브넷에 배치
  security_groups    = [aws_security_group.alb_sg.id] # 연결된 보안 그룹 ID

  enable_deletion_protection = false # 삭제 방지 비활성화
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.lb.arn # 연결할 로드 밸런서 ARN
  port              = 80            # 리스너 포트 번호
  protocol          = "HTTP"        # 리스너 프로토콜

  default_action {
    target_group_arn = aws_lb_target_group.alb_tg.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "alb_tg" {
  name     = "alb-tg"
  port     = 80     # 타겟 그룹 포트 번호
  protocol = "HTTP" # 타겟 그룹 프로토콜
  vpc_id   = module.vpc.vpc_id

  health_check {
    path     = "/index.html" # 상태 확인 경로
    protocol = "HTTP"        # 상태 확인 프로토콜
  }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg.name # 연결할 오토 스케일링 그룹 이름
  lb_target_group_arn    = aws_lb_target_group.alb_tg.arn # 연결할 타겟 그룹 ARN
}

resource "aws_autoscaling_policy" "scale_out_policy" {
  name                   = "scale-out-policy"
  scaling_adjustment     = 1                              # 인스턴스 1개 추가
  adjustment_type        = "ChangeInCapacity"             # 용량 변경 유형으로 설정
  cooldown               = 300                            # 쿨다운 기간
  autoscaling_group_name = aws_autoscaling_group.asg.name # 대상 오토스케일링 그룹 이름
}

resource "aws_autoscaling_policy" "scale_in_policy" {
  name                   = "scale-in-policy"
  scaling_adjustment     = -1                             # 인스턴스 1개 감소
  adjustment_type        = "ChangeInCapacity"             # 용량 변경 유형으로 설정
  cooldown               = 300                            # 쿨다운 기간
  autoscaling_group_name = aws_autoscaling_group.asg.name # 대상 오토스케일링 그룹 이름
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "cpu-high"                                    # 알람 이름
  comparison_operator = "GreaterThanOrEqualToThreshold"               # 임계값 이상일 때 트리거
  evaluation_periods  = 2                                             # 평가 기간 2회
  threshold           = 60                                            # 임계값 60%
  metric_name         = "CPUUtilization"                              # CPU 사용률 메트릭
  namespace           = "AWS/EC2"                                     # 메트릭 네임스페이스
  period              = 120                                           # 평가 측정 주기
  statistic           = "Average"                                     # 평균 값 사용
  alarm_actions       = [aws_autoscaling_policy.scale_out_policy.arn] # 스케일 아웃 정책으로 연결

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name # ASG 이름과 연결
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "cpu-low"                                    # 알람 이름
  comparison_operator = "LessThanOrEqualToThreshold"                 # 임계값 이하일 때 트리거
  metric_name         = "CPUUtilization"                             # CPU 사용률 메트릭
  namespace           = "AWS/EC2"                                    # 메트릭 네임스페이스
  statistic           = "Average"                                    # 평균 값 사용
  threshold           = 30                                           # 임계값 30%
  evaluation_periods  = 2                                            # 평가 기간 2회
  period              = 120                                          # 평가 측정 주기
  alarm_actions       = [aws_autoscaling_policy.scale_in_policy.arn] # 스케일 인 정책으로 연결

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name # ASG 이름과 연결
  }
}
