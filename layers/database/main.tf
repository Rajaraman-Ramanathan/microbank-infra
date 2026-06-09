module "rds_postgres" {
  source = "../../modules/database/rds_postgres"

  name = "microbank-postgres"

  vpc_id        = data.terraform_remote_state.network.outputs.vpc_id

  db_subnet_ids = data.terraform_remote_state.network.outputs.db_subnet_ids

  security_group_id = data.terraform_remote_state.network.outputs.rds_sg_id

  kms_key_arn = data.terraform_remote_state.kms.outputs.key_arn

  backup_window = local.backup_window
  maintenance_window = local.maintenance_window

  master_username = "postgres"

  instance_class = "db.t4g.medium"

  engine_version = "17.5"

  parameter_group_family = "postgres17"

  allocated_storage     = 100
  max_allocated_storage = 500

  multi_az = true

  tags = local.common_tags
}

module "postgres_bootstrap" {
  source = "../../modules/database/postgres_bootstrap"

  endpoint = module.rds_postgres.address
  secret_arn = module.rds_postgres.master_secret_arn

  depends_on = [
    module.rds_postgres
  ]
}