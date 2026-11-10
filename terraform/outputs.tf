output "alb_dns_name" {
  value = aws_lb.main.dns_name
}
output "ansible_ssm_bucket" {
  value = aws_s3_bucket.ansible_ssm.id
}