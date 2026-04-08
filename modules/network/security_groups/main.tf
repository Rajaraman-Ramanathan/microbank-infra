resource "aws_security_group" "this" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  tags = var.tags
}

# Ingress rules
resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = {
    for idx, rule in local.ingress_rules_expanded :
    idx => rule
  }

  security_group_id = aws_security_group.this.id

  from_port   = each.value.from_port
  to_port     = each.value.to_port
  ip_protocol = each.value.protocol
  cidr_ipv4   = each.value.cidr_block
  description = each.value.description
}

# Egress rules
resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = {
    for idx, rule in local.egress_rules_expanded :
    idx => rule
  }

  security_group_id = aws_security_group.this.id

  from_port   = each.value.from_port
  to_port     = each.value.to_port
  ip_protocol = each.value.protocol
  cidr_ipv4   = each.value.cidr_block
  description = each.value.description
}