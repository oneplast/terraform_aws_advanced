##########################################
# S3
##########################################
resource "random_integer" "random_suffix" {
  min = 1000
  max = 9999
}

resource "random_string" "random_string_suffix" {
  length  = 8
  special = false
  upper   = false
}

##########################################
# S3
# - 객체 스토리지
##########################################
resource "aws_s3_bucket" "s3" {
  bucket = "${var.bucket_name}-${random_integer.random_suffix.result}"

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

resource "aws_s3_bucket_public_access_block" "s3_access_block" {
  bucket = aws_s3_bucket.s3.id

  block_public_acls       = true # Public ACL을 새로 설정하지 못하게 방지
  block_public_policy     = true # Public 권한을 부여하는 버킷 정책 차단
  restrict_public_buckets = true # 버킷이 공개 상태가 되는 것을 제한
  ignore_public_acls      = true # 기존 Public ACL이 있더라도 무시
}

# S3 버저닝
# 동일한 키로 파일을 다시 업로드해도, 이전 객체를 오버라이팅하지 않고 여러 버전으로 보존
resource "aws_s3_bucket_versioning" "s3_versioning" {
  bucket = aws_s3_bucket.s3.id

  versioning_configuration {
    status = "Enabled"
  }
}

data "archive_file" "archive_index" {
  type = "zip" # Zip 형식으로 압축

  source_dir  = "${path.module}/hello-world" # hello-world 디렉터리 안의 모든 파일 압축
  output_path = "${path.module}/index.zip"   # Terraform 파일이 있는 디렉터리에 index.zip 생성
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.s3.id                         # 앞서 생성한 S3 버킷
  key    = var.index_key                               # S3 객체 키 - 현재 값: index.zip
  source = data.archive_file.archive_index.output_path # 로컬에서 생성된 ZIP 파일

  depends_on = [aws_s3_bucket_versioning.s3_versioning]

  # ZIP 파일 내용이 변경되면 MD5 값 변경(해시)
  # Terraform이 변경을 감지하여, 변경 시 S3 객체를 재업로드
  etag = filemd5(data.archive_file.archive_index.output_path)
}

##########################################
# Lambda
# - 서버를 직접 생성하고 관리하지 않고, 함수를 실행하는 FaaS 서비스
##########################################
resource "aws_lambda_function" "lambda_function" {
  function_name     = var.lambda_function_name       # AWS 콘솔에 표시될 Lambda 이름
  s3_bucket         = aws_s3_bucket.s3.id            # Lambda 코드가 저장된 S3 버킷
  s3_key            = aws_s3_object.index.key        # Lambda 코드 ZIP의 S3 키
  s3_object_version = aws_s3_object.index.version_id # S3 버저닝 정보를 함께 사용하여, Lambda 코드 업데이트
  handler           = var.lambda_handler             # index.js 파일의 handler expert 실행
  runtime           = var.lambda_runtime             # 실행 환경(Node.js)
  memory_size       = var.lambda_memory_size         # Lambda 실행 환경에 할당할 메모리
  timeout           = var.lambda_timeout             # 한 번의 요청이 실행될 수 있는 최대 시간
  role              = aws_iam_role.lambda_role.arn   # Lambda가 실행 중 사용할 IAM ROle

  # ZIP 내용이 바뀌면 Lambda 코드 업데이트 발생
  # source_code_hash = data.archive_file.archive_index.output_base64sha256

  environment {
    variables = {
      STAGE = var.environment
    }
  }
}

##########################################
# IAM
# - AWS 리소스에 대한 인증과 권한 관리
##########################################
resource "aws_iam_role" "lambda_role" {
  name = "lambda_role_${random_string.random_string_suffix.result}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com" # 이 Role을 사용할 수 있는 주체는 Lambda 서비스
        },
        Action = "sts:AssumeRole" # Lambda가 Role을 맡는 행위를 허용
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_role_attachment" {
  role       = aws_iam_role.lambda_role.name                                      # 정책을 연결할 IAM Role
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole" # AWS에서 관리하는 Lambda 기본 실행 정책
}

##########################################
# API Gateway
# - V2 리소스는 HTTP API, WebSocket API에 사용
# - V1 리소스는 REST API에 사용
##########################################
resource "aws_apigatewayv2_api" "gateway_api" {
  name          = var.api_name # API Gateway 이름
  protocol_type = "HTTP"       # HTTP API 생성
}

# AWS_PROXY
# - API Gateway가 요청을 Lambda 이벤트로 그대로 전달하고,
# - Lambda의 응답 객체를 HTTP 응답으로 사용
#
# 장점
# - 별도의 요청 매핑 템플릿이 거의 불필요
# - 헤더, 경로, 쿼리 파라미터를 Lambda에서 직접 처리 가능
# - Lambda가 statusCode, headers, body를 직접 결정
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.gateway_api.id            # 어느 API에 통합을 추가할지 지정
  integration_type       = "AWS_PROXY"                                    # Lambda의 반환값을 HTTP 응답으로 사용하는 프록시 통합
  integration_uri        = aws_lambda_function.lambda_function.invoke_arn # 호출할 Lambda 함수
  payload_format_version = "2.0"                                          # API Gateway가 Lambda에 전달할 이벤트 형식
}

# 모든 경로를 하나의 Lambda로 넘기고 싶다면,
# route_key = "ANY /{proxy+}"
resource "aws_apigatewayv2_route" "gateway_route" {
  api_id    = aws_apigatewayv2_api.gateway_api.id
  route_key = "GET /"                                                              # GET 메서드로 루트 경로만 허용
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}" # 이 Route 요청을 Lambda Integration으로 전달
}

# API Gateway에 Lambda 실행 권한 부여
# Lambda 함수의 Resource-based Policy에 API Gateway 호출 권한 추가
resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"                    # Lambda 리소스 정책 Statement ID
  action        = "lambda:InvokeFunction"                           # Lambda 호출 권한
  function_name = aws_lambda_function.lambda_function.function_name # 권한을 추가할 Lambda
  principal     = "apigateway.amazonaws.com"                        # API Gateway 서비스에 허용

  source_arn = "${aws_apigatewayv2_api.gateway_api.execution_arn}/*/*" # API Gateway ARN
}

# API Gateway 스테이지 설정 (dev 환경)
# 경로에 dev를 통해서 요청하도록 구성 가능
# https://~.us-aest-1.amazonaws.com/dev/hello
resource "aws_apigatewayv2_stage" "dev" {
  api_id      = aws_apigatewayv2_api.gateway_api.id
  name        = "dev"
  auto_deploy = true # Route 변경 시 별도 배포 리소스 없이 자동 반영
}

# API Gateway 스테이지 설정 (default 환경)
# 경로에 스테이지를 생략해서 요청하도록 구성 가능
# https://~.us-east-1.amazonaws.com/hello
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.gateway_api.id
  name        = "$default" # URL에서 Stage 이름 생략
  auto_deploy = true
}

##########################################
# CloudFront
# 전 세계 Edge Location을 통해 요청을 받아 Origin으로 전달하는 CDN이자 리버스 프록시
# 정적 파일 뿐 아니라 동적 API 요청도 전달 가능
#
# 현재는 캐시를 완전히 끄고 있으므로, 항상 Origin에 요청
# 성능 캐시보다는 다음과 같은 목적으로 사용
# - AWS WAF 연결
# - HTTPS 강제
# - 전 세계 Edge 진입점 제공
# - 나중에 캐싱 정책 적용 가능
##########################################
resource "aws_cloudfront_distribution" "cloudfront" {
  origin {
    # API Gateway invoke_url 예:
    # https://abc123.execute-api.us-east-1.amazonaws.com/
    #
    # CloudFront domain_name에는 프로토콜과 경로가 들어가면 안 되므로
    # abc123.execute-api.us-east-1.amazonaws.com 만 추출
    domain_name = replace(aws_apigatewayv2_stage.default.invoke_url, "/^https?://([^/]*).*/", "$1")
    origin_id   = "APIGateway" # 이 Origin을 식별하는 내부 이름

    custom_origin_config {
      http_port              = 80           # HTTP Origin 포트
      https_port             = 443          # HTTPS Origin 포트
      origin_protocol_policy = "https-only" # CloudFront -> API Gateway 통신은 HTTPS만 허용
      origin_ssl_protocols   = ["TLSv1.2"]  # TLS 1.2 이상 사용
    }
  }

  enabled         = true # 배포 활성화
  is_ipv6_enabled = true # IPv6 지원

  # API Origin(GET / 으로 라우팅)이므로 기본 문서가 필요하지 않음
  # 빈 문자열 대신, 속성 생략 가능
  default_root_object = "" # 생략 가능

  viewer_certificate {
    cloudfront_default_certificate = true # CloudFront가 기본으로 제공하는 *.cloudFront.net 인증서 사용
  }

  default_cache_behavior {
    # CloudFront가 Origin으로 전달할 수 있는 HTTP Method
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"] # 캐싱 대상이 될 수 있는 Method
    target_origin_id = "APIGateway"    # 요청을 전달할 Origin

    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6" # AWS 관리형 CachingDisabled 정책

    # Host를 제외한 요청 헤더, 쿠키, 쿼리 스트링을 Origin에 전달
    # AWS 관리형 AllViewerExceptionHostHeader 정책
    origin_request_policy_id = "b689b0a8-53d0-40ab-baf2-68738e2966ac"

    viewer_protocol_policy = "redirect-to-https" # 사용자가 HTTP로 접근하면 HTTPS로 리다이렉트

    # 현재 cache_policy_id가 캐시 비활성화 정책이므로, 아래 ttl 값들은 의미 없음 (문제에서 요구하므로 일단은 설정)
    min_ttl     = 0
    default_ttl = 0
    max_ttl     = 0
  }

  restrictions {
    geo_restriction {
      restriction_type = "none" # 국가 제한 없이 모든 국가 허용

      # KR, US 국가만 허용 (문제 요구사항이 아니므로 주석 처리)
      # locations = ["KR", "US"]
    }
  }

  web_acl_id = aws_wafv2_web_acl.waf.arn # CloudFront로 들어오는 요청을 WAF에서 먼저 검사
}

##########################################
# VPC
# - AWS 계정 안에 만드는 논리적인 사설 네트워크
##########################################
locals {
  aws_zone_mapping = {
    "us-east-1"      = ["a", "b", "c"]
    "ap-northeast-2" = ["a", "b", "c"]
  }

  azs = [for az in local.aws_zone_mapping[var.aws_region] : "${var.aws_region}${az}"]
}

# 현재 Lambda에는 다음 같은 설정이 존재하지 않음
# vpc_config {
#   subnet_ids = [...]
#   security_group_ids = [...]
# }
#
# 따라서, 현재 Lambda는 이 VPC 안에 들어가지 않음
# API Gateway, CloudFront도 현재 VPC의 Subnet을 사용하지 않음
#
# 즉 현재 VPC는 사실상, Private Route 53 Hosted Zone 생성 용도로만 사용
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws" # Terraform Registry의 검증된 VPC 모듈 사용
  version = "5.21.0"                        # 모듈 버전 고정을 통해, 모듈 업데이트로 인한 인프라 변경 방지

  name = var.vpc_name # VPC 이름
  cidr = var.vpc_cidr # VPC 전체 IP 범위

  azs             = local.azs                                           # 현재 3개 가용 영역
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]       # 외부에서 직접 접근하지 못하는 Private Subnet
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"] # Internet Gateway 경로를 가질 Public Subnet

  enable_nat_gateway = false # NAT Gateway 비생성
  single_nat_gateway = false # 단일 NAT Gateway 비생성

  # Public IP/EIP가 있는 EC2에 Public DNS Hostname 할당 지원
  # Private Hosted Zone 사용 조건의 일부
  enable_dns_hostnames = true
  enable_dns_support   = true # VPC 내부에서 Route 53 Resolver를 향한 DNS 해석 활성화

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}

##########################################
# Route 53
# - DNS 서비스
# - 사람이 기억하기 어려운 자동 생성된 주소(ex: d123456abcdef.cloudfront.net)를,
# - 지정한 도메인으로 사용하도록 설정(ex: api.my-domain.com)
#
# 현재는 Priavte Hosted Zone으로 설정하여, CloudFront와의 연결 효과 미비(제공된 문제 풀이용 샘플)
# 실제 운영 시에는 Public Hosted Zone으로 설정하고, 인증서 설정 필요
##########################################
resource "aws_route53_zone" "hosted_zone" {
  name = var.route53_zone # Hosted Zone 도메인
  vpc {
    vpc_id     = module.vpc.vpc_id # 특정 VPC에 연결
    vpc_region = var.aws_region    # 해당 VPC 리전
  }
}

resource "aws_route53_record" "api" {
  zone_id = aws_route53_zone.hosted_zone.id # 레코드를 생성할 Hosted Zone
  name    = "api.${var.route53_zone}"       # api.my-domain.com 형태

  # IPv4 주소를 나타내는 A 레코드
  # 실제 고정 IP가 아닌, Alias 사용 (CNAME 같이)
  type = "A"

  alias {
    name                   = aws_cloudfront_distribution.cloudfront.domain_name    # CloudFront Distribution 도메인
    zone_id                = aws_cloudfront_distribution.cloudfront.hosted_zone_id # CloudFront용 Route 53 Hosted Zone ID
    evaluate_target_health = false                                                 # CloudFront Alias에서는 보통 false (헬스 체크 불필요)
  }
}

##########################################
# WAF
# - HTTP 요청 내용을 검사하는 웹 어플리케이션 방화벽
#
# 일반 네트워크 방화벽과 달리, 다음과 같은 애플리케이션 계층 공격 검사
# - SQL Injection
# - XSS
# - 악성 요청 패턴
# - 비정상 URI
# - 악성 헤더
#
# 현재 설정상, API Gateway $default 주소가 외부에 공개
# - API Gateway 주소를 직접 호출하면 CloudFront, WAF를 패싱
# - 결과적으로 CloudFront 설정 및 WAF 설정을 무시한 채 API Gateway에 접근 가능
##########################################
resource "aws_wafv2_web_acl" "waf" {
  # WAF는 Terraform에서 us-east-1 리전에서 생성 필요
  # 현재는 var.aws_region이 us-east-1 이라 생략 가능
  # provider = "us-east-1"
  name  = var.waf_name # WAF 이름
  scope = "CLOUDFRONT" # WAF를 CloudFront에 연결

  # 규칙에 걸리지 않으면 기본적으로 허용
  default_action {
    allow {}
  }

  # AWS 관리형 규칙 그룹(AWSManagedRulesCommonRuleSet) 사용
  #
  # 장점
  # - 빠르게 기본 보안 적용
  # - AWS가 규칙 업데이트
  # - SQL Injection, XSS 등의 일반 공격 패턴 대응
  #
  # 주의
  # - 정상 요청이 오탐으로 차단될 수 있음
  # - 적용 전 Count 모드 테스트가 유용
  # - 인증과 인가를 대신 해주지는 않음
  rule {
    name     = "AWSManagedRulesCommonRuleSet" # AWS에서 제공하는 공통 공격 방어 규칙 그룹
    priority = 1                              # 숫자가 낮을수록 먼저 평가

    # 관리형 규칙 그룹의 기본 Action을 그대로 사용
    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet" # AWS 관리형 공통 규칙
        vendor_name = "AWS"                          # 규칙 제공자 -> AWS
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true                                 # 규칙 단위 CloudWatch Metrics 설정
      sampled_requests_enabled   = true                                 # 일부 요청 샘플을 WAF 콘솔에서 확인
      metric_name                = "AWSManagedRulesCommonRuleSetMetric" # CloudWatch Metric 이름
    }
  }

  visibility_config {
    sampled_requests_enabled   = true                  # Web ACL 전체 요청 샘플
    cloudwatch_metrics_enabled = true                  # Web ACL 전체 CloudWatch Metrics
    metric_name                = "ServerlessWAFMetric" # Web ACL 전체 Metric 이름
  }
}

##########################################
# CloudWatch
# - 애플리케이션 로그 보관
# - CloudWatch 로그 그룹 생성, Lambda 로그 수집 및 모니터링
##########################################
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.lambda_function.function_name}" # Lambda가 기본으로 사용하는 로그 그룹 이름 규칙
  retention_in_days = 14                                                                 # 14일이 지난 로그는 자동 삭제
}

# SNS 토픽 생성
resource "aws_sns_topic" "lambda_errors" {
  name = "lambda-errors-topic" # 알람 메시지를 발행할 주제
}

# SNS 토픽 구독 생성 (이메일 알림을 위한 예시)
resource "aws_sns_topic_subscription" "lambda_errors_email" {
  topic_arn = aws_sns_topic.lambda_errors.arn # 구독할 SNS Topic
  protocol  = "email"                         # 이메일 프로토콜 사용
  endpoint  = var.email                       # 알림 수신 이메일
}

# CloudWatch 알람 리소스 정의 (Lambda 함수 에러 감시)
# Lambda의 Errors 메트릭을 감시하고, 에러가 한 건이라도 발생하면 SNS로 알림 전송
#
# HTTP 500을 반환한다고 해서 Lambda Error는 아님
# - throw new Error() -> 감시 가능
# - 애플리케이션이 의도적으로 반환한 HTTP 4xx/5xx -> 감시 불가능
# 이것까지 감시하기 위해서는, API Gateway 메트릭이나 커스텀 메트릭을 함께 사용해야 함
resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  alarm_name          = var.alarm_name                       # CloudWatch Alarm 이름
  comparison_operator = "GreaterThanThreshold"               # 측정값이 threshold보다 크면 위반
  evaluation_periods  = 1                                    # 한 번의 평가 기간만 위반해도 ALARM
  metric_name         = "Errors"                             # Lambda 오류 수 메트릭
  namespace           = "AWS/Lambda"                         # Lambda Metric Namespace
  period              = 60                                   # 60초 단위 집계
  statistic           = "Sum"                                # 60초 동안 발생한 오류 수 합계
  threshold           = 0                                    # 오류가 0보다 크면 알람
  alarm_description   = "This metric monitors lambda errors" # 알람 설명
  alarm_actions       = [aws_sns_topic.lambda_errors.arn]    # ALARM 상태로 변경되면 SNS Topic으로 알림

  dimensions = {
    FunctionName = aws_lambda_function.lambda_function.function_name # 특정 Lambda 함수의 Errors만 감시
  }
}

# CloudWatch Dashboard
# 여러 메트릭을 한 화면에 그래프로 표시
# 현재 의도는 다음 세 지표
# - Lambda Invocations
# - Lambda Errors
# - API Gateway Count
resource "aws_cloudwatch_dashboard" "dashboard" {
  dashboard_name = var.dashboard_name # 대시보드 이름

  # CloudWatch Dashboard는 JSON 문자열을 요구
  # Terraform 객체를 jsonencode로 JSON 변환
  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric" # 메트릭 그래프

        # 대시보드 배치 위치
        x = 0
        y = 0

        # 위젯 크기
        width  = 12
        height = 6

        properties = {
          metrics = [
            # Lambda 호출 횟수
            ["AWS/Lambda", "Invocations", "FunctionName", aws_lambda_function.lambda_function.function_name],

            # "."은 이전 행의 Namespace와 Dimension을 재사용
            # - Namespace -> AWS/Lambda
            # - Dimension Name -> FunctionName
            # - Dimension Value1 -> aws_lambda_function.lambda_function.function_name
            [".", "Errors", ".", "."],

            # API Gateway 요청 수
            ["AWS/ApiGateway", "Count", "ApiName", aws_apigatewayv2_api.gateway_api.id]
          ]
          view    = "timeSeries"                     # 시간 흐름 그래프
          stacked = false                            # 각 지표를 누적하지 않고 별도 표시
          region  = var.aws_region                   # 메트릭 리전
          title   = "Lambda and API Gateway Metrics" # 위젯 제목

          # 모든 횟수 Metric을 1분 단위 합계로 표시
          stat   = "Sum"
          period = 60
        }
      }
    ]
  })
}
