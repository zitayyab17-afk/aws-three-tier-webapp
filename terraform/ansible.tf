resource "aws_s3_bucket" "ansible_ssm" {
  bucket_prefix = "webapp-ansible-ssm-"
  force_destroy = true

  tags = {
    Name = "webapp-ansible-ssm"
  }
}