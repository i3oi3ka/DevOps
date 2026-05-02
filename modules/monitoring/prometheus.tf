resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus"
  namespace        = "monitoring"
  version          = "25.0.0"
  create_namespace = true

  cleanup_on_fail = true

  set = [
    {
      name  = "service.service.type"
      value = "LoadBalancer"
    },
    {
      name  = "grafana.enabled"
      value = "false"
    }
  ]
}
