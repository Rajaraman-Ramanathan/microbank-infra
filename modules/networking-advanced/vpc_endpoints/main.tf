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
    var.vpce_security_group_id
  ]

  private_dns_enabled = true

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-${each.key}-endpoint"
    }
  )
}

