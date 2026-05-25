module "cloudwatch" {
  source = "../../modules/observability/cloudwatch"

  kms_key_arn = module.kms.key_arn
  log_groups = [
    {
      name = "/aws/eks/microbank"
      retention_days = 30
    },
    {
      name = "/aws/security/cloudtrail"
      retention_days = 365
    },
    {
      name = "/aws/vpc/flowlogs"
      retention_days = 30
    }
  ]

  metric_filters = [
    {
      name         = "unauthorized-api"
      log_group    = "/aws/security/cloudtrail"
      pattern      = "{ $.errorCode = \"*Unauthorized*\" }"
      metric_name  = "UnauthorizedAPICalls"
      namespace    = "Security"
    }
  ]

  tags = local.common_tags
}

module "alarms" {
  source = "../../modules/observability/alarms"

  name = "microbank"
  kms_key_arn = module.kms.key_arn
  alarms = local.alarms
  subscriptions = [
    {
      protocol = "email"
      endpoint = "platform-team@microbank.com"
    }
  ]

  tags = local.common_tags
}