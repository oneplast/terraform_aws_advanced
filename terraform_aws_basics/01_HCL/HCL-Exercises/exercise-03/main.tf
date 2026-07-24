variable "cities" {
  description = "도시 지역"
  type        = list(string)
  default     = ["Seoul", "Tokyo", "New York"]
}

locals {
  prefixed_cities = [for city in var.cities : "City: ${city}"]
}

output "print_cities" {
  value = local.prefixed_cities
}
