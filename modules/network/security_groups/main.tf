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

resource "aws_vpc_security_group_ingress_rule" "sg_rules" {
  for_each = {
    for idx, rule in flatten([
      for ingress_rule in var.ingress_rules : [
        for sg in ingress_rule.source_security_group_ids : {
          from_port   = ingress_rule.from_port
          to_port     = ingress_rule.to_port
          protocol    = ingress_rule.protocol
          description = ingress_rule.description
          sg_id       = sg
        }
      ]
    ]) : idx => rule
  }

  security_group_id            = aws_security_group.this.id
  referenced_security_group_id = each.value.sg_id
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  ip_protocol = each.value.protocol
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

resource "aws_vpc_security_group_egress_rule" "sg_rules" {
  for_each = {
    for idx, rule in flatten([
      for egress_rule in var.egress_rules : [
        for sg in egress_rule.source_security_group_ids : {
          from_port   = egress_rule.from_port
          to_port     = egress_rule.to_port
          protocol    = egress_rule.protocol
          description = egress_rule.description
          sg_id       = sg
        }
      ]
    ]) : idx => rule
  }

  security_group_id            = aws_security_group.this.id
  referenced_security_group_id = each.value.sg_id
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  ip_protocol = each.value.protocol
  description = each.value.description
}