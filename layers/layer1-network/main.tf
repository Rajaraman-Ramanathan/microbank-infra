data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "../../modules/network/vpc"

  name       = "${local.name}-vpc"
  cidr_block = local.cidr_block

  tags = local.common_tags
}

module "subnets" {
  source = "../../modules/network/subnets"

  name   = local.name
  vpc_id = module.vpc.vpc_id

  azs = slice(data.aws_availability_zones.available.names, 0, 2)

  public_subnet_cidrs  = local.public_subnet_cidrs
  private_subnet_cidrs = local.private_subnet_cidrs
  db_subnet_cidrs      = local.db_subnet_cidrs

  cluster_name = "${local.name}-eks"

  tags = local.common_tags
}