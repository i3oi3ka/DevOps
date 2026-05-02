# --- Змінні для S3 Backend ---
variable "bucket_name" {
  description = "Назва S3 бакета для збереження стану Terraform"
  type        = string
  default     = "ruday-terraform-state-bucket-devops" # Можна змінити на унікальне ім'я
}

variable "table_name" {
  description = "Назва DynamoDB таблиці для блокування стану Terraform"
  type        = string
  default     = "ruday-terraform-locks-devops" # Можна змінити на унікальне ім'я
}

# --- Змінні для VPC ---
variable "vpc_name" {
  description = "Ім'я VPC"
  type        = string
  default     = "devops-vpc"
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
  default     = "devops-ecr-repository"
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
  default     = "devops-eks-cluster"
}


variable "node_group_name" {
  description = "Name of the node group"
  default     = "devops-node-group"
}

variable "instance_type" {
  description = "EC2 instance type for the worker nodes"
  default     = "t3.small"
}

variable "desired_size" {
  description = "Desired number of worker nodes"
  default     = 3
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  default     = 4
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
  default     = "devops-rds-cluster"
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
  default = "17.9"
}

variable "instance_class" {
  type    = string
  default = "db.t3.micro"
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

variable "django_secret_key" {
  description = "Django SECRET_KEY. Should be passed via a secure external mechanism such as TF_VAR_django_secret_key, a secrets manager, or a tfvars file outside VCS."
  type        = string
  sensitive   = true
}

variable "github_username" {
  description = "GitHub username used by Jenkins for repository access."
  type        = string
}

variable "github_token" {
  description = "GitHub token used by Jenkins. Should be passed via a secure external mechanism such as TF_VAR_github_token, a secrets manager, or a tfvars file outside VCS."
  type        = string
  sensitive   = true
}

variable "jenkins_admin_password" {
  description = "Admin password for Jenkins. In production, use a secure method to manage this password, such as Kubernetes secrets or Terraform variables marked as sensitive."
  type        = string
  sensitive   = true
}

variable "publicly_accessible" {
  type    = bool
  default = false
}

variable "multi_az" {
  type    = bool
  default = false
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
  default = 0
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
  default = "15.8"
}
variable "parameter_group_family_rds" {
  type    = string
  default = "postgres17"
}

# --- Змінні для моніторингу ---
variable "grafana_admin_password" {
  description = "The password for the Grafana admin user"
  type        = string
  sensitive   = true
}
variable "prometheus_admin_password" {
  description = "The password for the Prometheus admin user"
  type        = string
  sensitive   = true
}

