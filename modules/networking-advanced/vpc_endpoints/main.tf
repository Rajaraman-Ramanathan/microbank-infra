resource "aws_security_group" "vpce" {
  name        = "${var.name}-vpce-sg"
  description = "VPC Endpoint Security Group"
  vpc_id      = var.vpc_id

  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  for_each = toset(var.private_subnet_cidrs)
  security_group_id = aws_security_group.vpce.id
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
  cidr_ipv4 = each.value
  description = "HTTPS from private subnets"
}

resource "aws_vpc_endpoint" "gateway" {
  for_each = local.gateway_endpoints
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.${each.value.service_name}"
  vpc_endpoint_type = "Gateway"
  route_table_ids = var.private_route_table_ids

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-${each.key}"
    }
  )
}

resource "aws_vpc_endpoint" "interface" {
  for_each = local.interface_endpoints
  vpc_id = var.vpc_id
  service_name = "com.amazonaws.${var.region}.${each.value.service_name}"
  vpc_endpoint_type = "Interface"
  subnet_ids = var.private_subnet_ids

  security_group_ids = [
    aws_security_group.vpce.id
  ]

  private_dns_enabled = true

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-${each.key}-endpoint"
    }
  )
}

