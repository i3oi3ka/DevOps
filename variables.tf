# --- Змінні для S3 Backend ---
variable "bucket_name" {
  description = "Назва S3 бакета для збереження стану Terraform"
  type        = string
}

variable "table_name" {
  description = "Назва DynamoDB таблиці для блокування стану Terraform"
  type        = string
}

# --- Змінні для VPC ---
variable "vpc_name" {
  description = "Ім'я VPC"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR блок для VPC"
  type        = string
}

variable "public_subnets" {
  description = "Список CIDR блоків для публічних підмереж"
  type        = list(string)
}

variable "private_subnets" {
  description = "Список CIDR блоків для приватних підмереж"
  type        = list(string)
}

variable "availability_zones" {
  description = "Список зон доступності для підмереж"
  type        = list(string)
}

# --- Змінні для ECR ---
variable "ecr_name" {
  description = "Назва ECR репозиторію"
  type        = string
}

variable "scan_on_push" {
  description = "Чи вмикати сканування образів при завантаженні"
  type        = bool
  default     = false
}
