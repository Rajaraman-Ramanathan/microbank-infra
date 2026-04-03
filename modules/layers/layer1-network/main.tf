module "vpc" {
  source = "../../modules/network/vpc"

  name       = "microbank-prod-vpc"
  cidr_block = "10.0.0.0/16"

  tags = {
    Environment = "prod"
    Project     = "microbank"
  }
}

module "subnets" {
  source = "../../modules/network/subnets"

  name   = "microbank-prod-subnets"
  vpc_id = module.vpc.vpc_id

  azs = ["ap-south-1a", "ap-south-1b"]

  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
  db_subnet_cidrs      = ["10.0.21.0/24", "10.0.22.0/24"]

  cluster_name = "microbank-eks"

  tags = {
    Environment = "prod"
    Project     = "microbank"
  }
}