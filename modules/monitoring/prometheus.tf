resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus"
  namespace        = "monitoring"
  create_namespace = true

  cleanup_on_fail = true

  set = [
    {
      name  = "service.service.type"
      value = "LoadBalancer"
    }
  ]
  set_sensitive = [
    {
      name  = "adminPassword"
      value = var.prometheus_admin_password
    }
  ]
}
