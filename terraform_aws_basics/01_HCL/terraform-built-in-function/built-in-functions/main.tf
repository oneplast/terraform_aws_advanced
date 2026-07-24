terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

variable "num1" {
  default = 10
}

variable "num2" {
  default = 20
}

output "max_value" {
  value = max(var.num1, var.num2)
}

variable "greeting" {
  default = "hello, terraform"
}

output "upper_greeting" {
  value = upper(var.greeting)
}

output "greeting_list" {
  value = split(", ", var.greeting)
}

variable "fruit_list" {
  default = ["apple", "banana", "cherry"]
}

output "joined_fruit" {
  value = join(",", var.fruit_list)
}

variable "bool_value" {
  default = true
}

output "string_value" {
  value = tostring(var.bool_value)
}

variable "config_path" {
  default = "config.txt"
}

check "config_file_exists" {
  assert {
    condition     = fileexists(var.config_path)
    error_message = "Configuration file does not exist at the specified path."
  }
}

output "file_content" {
  value = file(var.config_path)
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

output "subnet_cidr" {
  value = cidrsubnet(var.vpc_cidr, 8, 1)
}

output "host_ip" {
  value = cidrhost(var.vpc_cidr, 5)
}

resource "random_integer" "example" {
  min = 1
  max = 100
}

output "random_integer_value" {
  value = random_integer.example.result
}
