variable "is_day" {
  description = "밤/낮여부"
  type        = bool
  default     = true
}

locals {
  greeting = var.is_day ? "Good day!" : "Good night!"
}

output "print_greeting" {
  value = local.greeting
}
