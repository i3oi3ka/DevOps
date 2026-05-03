variable "bucket_name" {
  description = "The name of the S3 bucket for Terraform state"
  type        = string
  default     = "ruday-devops-terraform-state-bucket"
}

variable "table_name" {
  description = "The name of the DynamoDB table for Terraform locks"
  type        = string
  default     = "ruday-devops-terraform-locks"
}

