output "tfstate_bucket" {
  value = aws_s3_bucket.tfstate.id
}

output "github_action_role_arn" {
  value = aws_iam_role.github_action.arn
}