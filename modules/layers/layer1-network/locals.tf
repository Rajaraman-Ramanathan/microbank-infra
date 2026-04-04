locals {
  name = "microbank-prod"
  cidr_block = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
  db_subnet_cidrs      = ["10.0.21.0/24", "10.0.22.0/24"]

  common_tags = {
    Environment = "prod"
    Project     = "microbank"
  }
}