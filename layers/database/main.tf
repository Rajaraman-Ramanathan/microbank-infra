module "rds_postgres" {
  source = "../../modules/database/rds_postgres"

  name = "microbank-postgres"
  vpc_id = module.network.vpc_id
  db_subnet_ids = module.network.db_subnet_ids
  kms_key_arn = module.kms.key_arn
  master_username = "postgres"
  instance_class = "db.t4g.medium"

  allowed_cidrs = [
    module.network.private_subnet_cidr
  ]

  tags = local.common_tags
}