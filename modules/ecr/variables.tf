variable "ecr_name" {
  description = "The name of the ECR repository"
  type        = string
  default     = "ruday-lesson-7-ecr-1101"
}

variable "scan_on_push" {
  description = "Whether to enable image scanning on push"
  type        = bool
  default     = true
}
