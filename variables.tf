variable "region" {
  description = "AWS регіон"
  type        = string
  default     = "eu-west-2"
}

variable "vpc_cidr_block" {
  description = "CIDR блок для VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "project_name" {
  description = "Назва проєкту для тегування"
  type        = string
  default     = "ruday-lesson-5"
}
