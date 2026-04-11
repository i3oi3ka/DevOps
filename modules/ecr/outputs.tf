output "ecr_id" {
  value = aws_ecr_repository.main.id
}

output "ecr_repository_url" {
  value = aws_ecr_repository.main.repository_url
}

output "ecr_scan_on_push" {
  # Зверніть увагу на структуру доступу до scan_on_push
  value = aws_ecr_repository.main.image_scanning_configuration[0].scan_on_push
}
