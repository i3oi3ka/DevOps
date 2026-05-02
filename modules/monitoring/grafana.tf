resource "helm_release" "grafana" {
  name             = "grafana"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  namespace        = "monitoring"
  create_namespace = true
  cleanup_on_fail  = true
  version          = "8.0.0"

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
