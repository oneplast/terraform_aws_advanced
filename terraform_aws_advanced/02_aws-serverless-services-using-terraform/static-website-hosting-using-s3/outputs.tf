output "bucket_name" {
  description = "The name of the S3 bucket."
  value       = aws_s3_bucket.static_site.bucket
}

output "website-url" {
  description = "The website URL for the S3 bucket"
  value       = aws_s3_bucket_website_configuration.static_site_website.website_endpoint
}
