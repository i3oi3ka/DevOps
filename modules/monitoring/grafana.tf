resource "helm_release" "grafana" {
  name            = "grafana"
  repository      = "https://grafana.github.io/helm-charts"
  chart           = "grafana"
  namespace       = "monitoring"
  cleanup_on_fail = true

  set = [
    {
      name  = "service.type"
      value = "LoadBalancer"
    }
  ]

  set_sensitive = [
    {
      name  = "adminPassword"
      value = var.grafana_admin_password
    }
  ]
}
