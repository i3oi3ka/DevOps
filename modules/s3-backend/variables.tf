variable "bucket_name" {
  description = "The name of the S3 bucket for Terraform state"
  type        = string
  default     = "ruday-lesson-7-terraform-state-bucket-1101"
}

variable "table_name" {
  description = "The name of the DynamoDB table for Terraform locks"
  type        = string
  default     = "ruday-lesson-7-terraform-locks-1101"
}

