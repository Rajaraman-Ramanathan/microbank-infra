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

module "igw" {
  source = "../../modules/network/igw"

  vpc_id = module.vpc.vpc_id
  name   = local.name
  tags   = local.common_tags
}

module "nat" {
  source = "../../modules/network/nat"

  public_subnet_id = module.subnets.public_subnet_ids[0]

  name = local.name
  tags = local.common_tags
}

module "route_tables" {
  source = "../../modules/network/route-tables"

  vpc_id = module.vpc.vpc_id
  igw_id = module.igw.igw_id
  nat_id = module.nat.nat_id

  public_subnet_ids  = module.subnets.public_subnet_ids
  private_subnet_ids = module.subnets.private_subnet_ids
  db_subnet_ids      = module.subnets.db_subnet_ids

  name = local.name
  tags = local.common_tags
}