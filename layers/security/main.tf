module "kms" {
  source = "../../modules/security/kms"

  name        = "microbank-kms"
  description = "Microbank platform KMS key"
  admin_principals = [
    "arn:aws:iam::123456789012:role/platform-admin"
  ]
  usage_principals = [
    module.node_role.node_role_arn
  ]

  tags = local.common_tags
}

module "db_secret" {
  source = "../../modules/security/secrets_manager"

  name        = "microbank-db-credentials"
  description = "Database credentials"
  kms_key_arn = module.kms.key_arn
  secret_map = {
    username = "admin"
    password = "super-secure-password"
    host     = "postgres.internal"
    port     = "5432"
  }
  enable_resource_policy = true
  allowed_principals = [
    module.node_role.node_role_arn
  ]

  tags = local.common_tags
}

module "api_secret" {
  source = "../../modules/security/secrets_manager"

  name        = "payment-api-key"
  description = "Payment provider API key"
  kms_key_arn = module.kms.key_arn
  secret_string = "super-secret-api-key"

  tags = local.common_tags
}

module "cloudtrail" {
  source = "../../modules/security/cloudtrail"

  name = "microbank-cloudtrail"
  kms_key_arn = module.kms.key_arn
  s3_bucket_name = module.audit_bucket.bucket_id
  s3_bucket_arn  = module.audit_bucket.bucket_arn
  log_retention_days = 365

  tags = local.common_tags
}

module "guardduty" {
  source = "../../modules/security/guardduty"

  name = "microbank-guardduty"
  finding_publishing_frequency = "FIFTEEN_MINUTES"

  tags = local.common_tags
}