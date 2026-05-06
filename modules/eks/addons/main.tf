resource "aws_eks_addon" "vpc_cni" {
  cluster_name = var.cluster_name
  addon_name   = "vpc-cni"

  resolve_conflicts_on_update = "OVERWRITE"

  configuration_values = jsonencode({
    env = {
      ENABLE_PREFIX_DELEGATION = "true"
      WARM_PREFIX_TARGET       = "1"
    }
  })

  tags = var.tags
}

resource "aws_eks_addon" "coredns" {
  cluster_name = var.cluster_name
  addon_name   = "coredns"

  resolve_conflicts_on_update = "OVERWRITE"

  tags = var.tags
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = var.cluster_name
  addon_name   = "kube-proxy"

  resolve_conflicts_on_update = "OVERWRITE"

  tags = var.tags
}

resource "aws_eks_addon" "ebs_csi" {
  cluster_name = var.cluster_name
  addon_name   = "aws-ebs-csi-driver"

  service_account_role_arn = var.ebs_csi_role_arn

  resolve_conflicts_on_update = "OVERWRITE"

  tags = var.tags
}

resource "helm_release" "alb_controller" {
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"

  values = [
    yamlencode({
      clusterName = var.cluster_name

      serviceAccount = {
        create = false
        name   = "aws-load-balancer-controller"
        annotations = {
          "eks.amazonaws.com/role-arn" = var.alb_irsa_role_arn
        }
      }
    })
  ]
}

