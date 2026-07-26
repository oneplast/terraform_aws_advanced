output "bucket_name" {
  description = "The name of the S3 bucket."
  value       = module.s3.bucket_id
}

output "bucket_domain_name" {
  description = "The domain name of the S3 bucket."
  value       = module.s3.bucket_domain_name
}

output "cloudfront_url" {
  description = "The URL of the CloudFront distribution"
  value       = module.cloudfront.cloudfront_domain_name
}
