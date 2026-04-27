# --- Змінні для S3 Backend ---
variable "bucket_name" {
  description = "Назва S3 бакета для збереження стану Terraform"
  type        = string
  default     = "ruday-terraform-state-bucket-devOps" # Можна змінити на унікальне ім'я
}

variable "table_name" {
  description = "Назва DynamoDB таблиці для блокування стану Terraform"
  type        = string
  default     = "ruday-terraform-locks-devOps" # Можна змінити на унікальне ім'я
}

# --- Змінні для VPC ---
variable "vpc_name" {
  description = "Ім'я VPC"
  type        = string
  default     = "DevOps-vpc"
}

variable "vpc_cidr_block" {
  description = "CIDR блок для VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Список CIDR блоків для публічних підмереж"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnets" {
  description = "Список CIDR блоків для приватних підмереж"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

}

variable "availability_zones" {
  description = "Список зон доступності для підмереж"
  type        = list(string)
  default     = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}

# --- Змінні для ECR ---
variable "ecr_name" {
  description = "Назва ECR репозиторію"
  type        = string
  default     = "DevOps-ecr-repository"
}

variable "scan_on_push" {
  description = "Чи вмикати сканування образів при завантаженні"
  type        = bool
  default     = true
}

# --- Змінні для EKS ---

variable "region" {
  description = "AWS region for deployment"
  default     = "eu-west-2"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  default     = "DevOps-eks-cluster"
}


variable "node_group_name" {
  description = "Name of the node group"
  default     = "DevOps-node-group"
}

variable "instance_type" {
  description = "EC2 instance type for the worker nodes"
  default     = "t3.small"
}

variable "desired_size" {
  description = "Desired number of worker nodes"
  default     = 2
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  default     = 3
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  default     = 1
}

#  --- Змінні для Argo CD ---

variable "name" {
  description = "Назва Helm-релізу"
  type        = string
  default     = "argo-cd"
}

variable "namespace" {
  description = "K8s namespace для Argo CD"
  type        = string
  default     = "argocd"
}

variable "chart_version" {
  description = "Версія Argo CD чарта"
  type        = string
  default     = "9.5.4"
}


# --- Змінні для RDS ---
variable "rds_cluster_name" {
  description = "Назва кластера RDS (для Aurora)"
  type        = string
  default     = "DevOps-rds-cluster"
}

variable "engine" {
  type    = string
  default = "postgres"
}
variable "engine_cluster" {
  type    = string
  default = "aurora-postgresql"
}
variable "aurora_replica_count" {
  type    = number
  default = 1
}

variable "aurora_instance_count" {
  type    = number
  default = 2 # 1 primary + 1 replica
}
variable "engine_version" {
  type    = string
  default = "17.2"
}

variable "instance_class" {
  type    = string
  default = "db.t3.small"
}

variable "allocated_storage" {
  type    = number
  default = 20
}

variable "db_name" {
  type    = string
  default = "devopsdb"
}

variable "username" {
  type    = string
  default = "postgres"
}

variable "password" {
  description = "Пароль для БД. Має бути переданий через безпечний зовнішній механізм (наприклад, TF_VAR_password, secrets manager або .tfvars файл поза VCS)."
  type        = string
  sensitive   = true
}

variable "vpc_id" {
  type = string
}

variable "subnet_private_ids" {
  type = list(string)
}

variable "subnet_public_ids" {
  type = list(string)
}

variable "publicly_accessible" {
  type    = bool
  default = false
}

variable "multi_az" {
  type    = bool
  default = true
}

variable "parameters" {
  type = map(string)
  default = {
    max_connections            = "200"
    log_min_duration_statement = "500"
  }
}

variable "use_aurora" {
  type    = bool
  default = false
}

variable "backup_retention_period" {
  type    = number
  default = 7
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "parameter_group_family_aurora" {
  type    = string
  default = "aurora-postgresql15"
}
variable "engine_version_cluster" {
  type    = string
  default = "15.3"
}
variable "parameter_group_family_rds" {
  type    = string
  default = "postgres15"
}
