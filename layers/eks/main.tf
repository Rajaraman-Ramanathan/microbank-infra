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