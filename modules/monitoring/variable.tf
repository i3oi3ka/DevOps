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
