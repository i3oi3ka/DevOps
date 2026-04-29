variable "name" {
  description = "Назва Helm-релізу"
  type        = string
  default     = "argo-cd"
}

variable "django_postgres_host" {
  description = "PostgreSQL host passed to the Django Helm chart."
  type        = string
}

variable "django_postgres_port" {
  description = "PostgreSQL port passed to the Django Helm chart."
  type        = number
  default     = 5432
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
