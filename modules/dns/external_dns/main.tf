resource "helm_release" "external_dns" {
  name             = "external-dns"
  repository       = "https://kubernetes-sigs.github.io/external-dns/"
  chart            = "external-dns"
  namespace        = "kube-system"
  create_namespace = false

  values = [
    yamlencode({
      provider = "aws"
      policy = var.policy
      registry = "txt"
      txtOwnerId = var.txt_owner_id
      domainFilters = var.domain_filters
      serviceAccount = {
        create = true
        name   = "external-dns"
        annotations = {
          "eks.amazonaws.com/role-arn" = var.external_dns_role_arn
        }
      }
      sources = [
        "service",
        "ingress"
      ]
      interval = "1m"
      triggerLoopOnEvent = true
      logLevel = "info"
      aws = {
        zoneType = var.zone_type
      }
    })
  ]
  timeout = 600
}