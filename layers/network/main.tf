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

module "vpc_endpoints" {
  source = "../../modules/networking-advanced/vpc_endpoints"

  name = "microbank"
  region = var.aws_region
  vpc_id = module.vpc.vpc_id
  private_subnet_ids      = module.subnets.private_subnet_ids
  private_route_table_ids = module.route_tables.private_route_table_ids
  private_subnet_cidrs = var.private_subnet_cidrs

  tags = local.common_tags
}

module "eks_cluster_sg" {
  source = "../../modules/network/security_groups"

  name        = "${local.name}-eks-cluster-sg"
  description = "EKS Control Plane Security Group"
  vpc_id = module.vpc.vpc_id
  ingress_rules = []

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = [
        "0.0.0.0/0"
      ]
      description = "Allow all outbound traffic"
    }
  ]

  tags = merge(
    local.common_tags,
    {
      Component = "eks-cluster-sg"
    }
  )
}

module "eks_node_sg" {
  source = "../../modules/network/security_groups"

  name        = "${local.name}-eks-node-sg"
  description = "EKS Worker Node Security Group"
  vpc_id = module.vpc.vpc_id
  ingress_rules = [
    {
      from_port   = 1025
      to_port     = 65535
      protocol    = "tcp"

      source_security_group_ids = [
        module.eks_cluster_sg.security_group_id
      ]
      
      description = "Control plane to nodes"
    },
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"

      source_security_group_ids = [
        module.eks_node_sg.security_group_id
      ]
      description = "Node to node communication"
    }
  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"

      cidr_blocks = [
        "0.0.0.0/0"
      ]
      description = "Allow all outbound traffic"
    }
  ]

  tags = merge(
    local.common_tags,
    {
      Component = "eks-node-sg"
    }
  )
}