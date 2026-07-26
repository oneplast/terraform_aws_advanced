output "bucket_name" {
  description = "생성된 S3 버킷의 실제 이름 (랜덤 숫자가 포함된 전체 이름)"
  value       = aws_s3_bucket.static_site.bucket
}

output "cloudfront_url" {
  description = "웹사이트 접속 주소 (브라우저에서 https://[이 값] 으로 접속하세요)"
  value       = "https://${aws_cloudfront_distribution.s3_distribution.domain_name}"
}
