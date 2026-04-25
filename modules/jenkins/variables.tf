variable "cluster_name" {
  description = "Назва Kubernetes кластера"
  type        = string
}

variable "kubeconfig" {
  description = "Зміст kubeconfig файлу для доступу до EKS кластера"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN провайдера OIDC для EKS"
  type        = string
}

variable "oidc_provider_url" {
  description = "URL провайдера OIDC для EKS"
  type        = string
}
