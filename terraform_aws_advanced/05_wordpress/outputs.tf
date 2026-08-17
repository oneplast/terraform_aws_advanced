# 1. 1차 terraform apply 에서는 전체 주석 처리(혹은 확장자 임시 변경) 필요
# 2. pakcer build 후 ami_id가 생성되면, terraform.tfvars에서 ami_id 값을 넣은 후 주석 해제
# 3. 이후 다시 terraform apply로 infra 구성
output "lb_dns" {
  value = aws_lb.wordpress.dns_name
}
