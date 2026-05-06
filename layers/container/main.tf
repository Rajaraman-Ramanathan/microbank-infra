module "ecr_app" {
  source = "../../modules/container/ecr"

  name          = "microbank-app"
  kms_key_arn   = module.kms.key_arn

  max_image_count = 100

  enable_repository_policy = true
  allowed_principals = [
    "arn:aws:iam::123456789012:role/ci-cd-role"
  ]

  tags = local.common_tags
}