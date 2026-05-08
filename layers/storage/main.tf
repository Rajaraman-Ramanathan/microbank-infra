module "app_bucket" {
  source = "../../modules/storage/s3"

  bucket_name = "microbank-app-prod"
  kms_key_arn = module.kms.key_arn
  versioning_enabled = true
  enable_bucket_policy = true
  allowed_principals = [
    "arn:aws:iam::123456789012:role/app-role"
  ]

  tags = local.common_tags
}

module "efs_shared" {
  source = "../../modules/storage/efs"

  name = "microbank-efs"
  kms_key_arn = module.kms.key_arn
  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
  private_subnet_cidr = module.network.private_subnet_cidr
  create_access_point = true

  tags = local.common_tags
}

module "platform_ebs" {
  source = "../../modules/storage/ebs"

  name = "platform-ebs"
  availability_zone = "ap-south-1a"
  size         = 100
  volume_type  = "gp3"
  kms_key_arn = module.kms.key_arn

  tags = local.common_tags
}

module "bastion_ebs" {
  source = "../../modules/storage/ebs"

  name = "bastion-ebs"
  availability_zone = "ap-south-1a"
  size         = 50
  volume_type  = "gp3"
  kms_key_arn = module.kms.key_arn
  attach_volume = true
  instance_id   = module.bastion.instance_id

  tags = local.common_tags
}