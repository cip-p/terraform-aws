output "repos_arn" {
  value = aws_ecr_repository.this.*.arn
}
output "repos_url" {
  value = aws_ecr_repository.this.*.repository_url
}
