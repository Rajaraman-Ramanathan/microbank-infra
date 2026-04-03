resource "aws_subnet" "public" {
  for_each = {
    for idx, az in var.azs :
    az => {
      cidr = var.public_subnet_cidrs[idx]
      az   = az
    }
  }

  vpc_id                  = var.vpc_id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name = "${var.name}-public-${each.key}"
      "kubernetes.io/role/elb" = "1"
      "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    },
    var.tags
  )
}

resource "aws_subnet" "private" {
  for_each = {
    for idx, az in var.azs :
    az => {
      cidr = var.private_subnet_cidrs[idx]
      az   = az
    }
  }

  vpc_id            = var.vpc_id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(
    {
      Name = "${var.name}-private-${each.key}"
      "kubernetes.io/role/internal-elb" = "1"
      "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    },
    var.tags
  )
}

resource "aws_subnet" "db" {
  for_each = {
    for idx, az in var.azs :
    az => {
      cidr = var.db_subnet_cidrs[idx]
      az   = az
    }
  }

  vpc_id            = var.vpc_id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(
    {
      Name = "${var.name}-db-${each.key}"
    },
    var.tags
  )
}