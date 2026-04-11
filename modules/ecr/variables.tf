variable "ecr_name" {
    description = "The name of the ECR repository"
    type        = string
  }
  
variable "scan_on_push" {
    description = "Whether to enable image scanning on push"
    type        = bool
    default     = false
  
}