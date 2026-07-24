module "module_greeting" {
  source = "./modules/greeting"

  greeting       = "Hello"
  message_prefix = "Welcome: "
}

output "print_module_output" {
  value = module.module_greeting.print_greeting
}
