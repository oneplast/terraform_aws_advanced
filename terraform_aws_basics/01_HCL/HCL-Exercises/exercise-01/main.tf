variable "greeting" {
  description = "인사말"
  type        = string
  default     = "Hello, Terraform!"
}

output "greeting_out" {
  value = "The greeting message is: ${var.greeting}"
}
