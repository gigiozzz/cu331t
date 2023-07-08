output "repository_url" {
  value = {
    for name, value in aws_ecr_repository.ecr : name => value.repository_url
  }
}