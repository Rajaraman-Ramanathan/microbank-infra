module "eks_cluster" {
  source = "../../modules/eks/cluster"

  cluster_name              = var.cluster_name
  cluster_version           = var.cluster_version
  private_subnet_ids        = module.network.private_subnet_ids
  cluster_role_arn          = module.iam.cluster_role_arn
  cluster_security_group_id = module.security_group.cluster_sg_id
  kms_key_arn               = module.kms.key_arn

  tags = local.common_tags
}

module "node_groups" {
  source = "../../modules/eks/node_groups"

  cluster_name       = module.eks_cluster.cluster_name
  node_role_arn      = module.iam.node_role_arn
  private_subnet_ids = module.network.private_subnet_ids
  node_groups = local.node_groups
   
  tags        = local.common_tags
}

module "cluster_role" {
  source = "../../modules/eks/iam/cluster_role"

  cluster_name = var.cluster_name
  tags         = local.common_tags
}

module "node_role" {
  source = "../../modules/eks/iam/node_role"

  cluster_name = var.cluster_name
  tags         = local.common_tags
}

module "oidc" {
  source = "../../modules/eks/oidc"

  cluster_name = module.eks_cluster.cluster_name
  tags = local.common_tags

  depends_on = [module.eks_cluster]
}

module "irsa_external_dns" {
  source = "../../modules/eks/iam/irsa"

  cluster_name        = var.cluster_name
  namespace           = "kube-system"
  service_account     = "external-dns"

  oidc_provider_arn   = module.oidc.arn
  oidc_provider_url   = module.oidc.url

  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
  ]

  tags = local.common_tags

  depends_on = [
    module.eks_cluster,
    module.oidc    
    ]
}

module "addons" {
  source = "../../modules/eks/addons"

  cluster_name        = module.eks_cluster.cluster_name

  ebs_csi_role_arn    = module.irsa_ebs_csi.role_arn
  alb_irsa_role_arn   = module.irsa_alb.role_arn

  tags = local.common_tags

  providers = {
    helm = helm
  }

  depends_on = [
    module.node_groups
  ]
}

module "irsa_ebs_csi" {
  source = "../../modules/eks/iam/irsa"

  cluster_name    = var.cluster_name
  namespace       = "kube-system"
  service_account = "ebs-csi-controller-sa"

  oidc_provider_arn = module.oidc.arn
  oidc_provider_url = module.oidc.url

  policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  ]
}

module "irsa_alb" {
  source = "../../modules/eks/iam/irsa"

  cluster_name    = var.cluster_name
  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller"

  oidc_provider_arn = module.oidc.arn
  oidc_provider_url = module.oidc.url

  policy_arns = [
    "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
  ]
}


