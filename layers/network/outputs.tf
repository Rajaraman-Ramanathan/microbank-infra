output "vpc_id" {
  value = module.vpc.vpc_id
}

output "db_subnet_ids" {
  value = module.subnets.db_subnet_ids
}

output "eks_cluster_sg_id" {
  value = module.eks_cluster_sg.security_group_id
}

output "eks_node_sg_id" {
  value = module.eks_node_sg.security_group_id
}

output "keycloak_sg_id" {
  value = module.keycloak_sg.security_group_id
}

output "rds_sg_id" {
  value = module.rds_sg.security_group_id
}

output "redis_sg_id" {
  value = module.redis_sg.security_group_id
}

output "amazonmq_sg_id" {
  value = module.amazonmq_sg.security_group_id
}

output "alb_public_sg_id" {
  value = module.alb_public_sg.security_group_id
}

output "vpce_sg_id" {
  value = module.vpce_sg.security_group_id
}