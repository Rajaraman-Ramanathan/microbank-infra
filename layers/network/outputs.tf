output "eks_cluster_sg_id" {
  value = module.eks_cluster_sg.security_group_id
}

output "eks_node_sg_id" {
  value = module.eks_node_sg.security_group_id
}