variable "cluster_name" {
  description = "Name of the Kubernetes cluster."
  type        = string
}

variable "kubeconfig" {
  description = "Path or contents used to access the EKS cluster."
  type        = string
}

variable "oidc_provider_arn" {
  description = "OIDC provider ARN for EKS."
  type        = string
}

variable "oidc_provider_url" {
  description = "OIDC provider URL for EKS."
  type        = string
}

variable "github_username" {
  description = "GitHub username used by Jenkins for repository access."
  type        = string
}

variable "github_token" {
  description = "GitHub token used by Jenkins for repository access."
  type        = string
  sensitive   = true
}

variable "jenkins_admin_password" {
  description = "Admin password for Jenkins. In production, use a secure method to manage this password, such as Kubernetes secrets or Terraform variables marked as sensitive."
  type        = string
  sensitive   = true
}
