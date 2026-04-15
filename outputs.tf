output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "ecr_repository_url" {
  description = "The URL of the ECR repository"
  value       = module.ecr.ecr_repository_url
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket used for Terraform state"
  value       = module.s3_backend.s3_bucket_name
}
