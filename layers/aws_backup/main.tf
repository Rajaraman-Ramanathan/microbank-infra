module "backup" {
  source = "../../modules/backup/aws_backup"

  name = "microbank"
  kms_key_arn = module.kms.key_arn
  retention_days = 35

  tags = local.common_tags
}