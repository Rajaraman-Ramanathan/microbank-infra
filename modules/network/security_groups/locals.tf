locals {
  ingress_rules_expanded = flatten([
    for rule in var.ingress_rules : [
      for cidr in rule.cidr_blocks : {
        from_port   = rule.from_port
        to_port     = rule.to_port
        protocol    = rule.protocol
        cidr_block  = cidr
        description = rule.description
      }
    ]
  ])

  referenced_ingress_rules_expanded = flatten([
    for ingress_rule in var.ingress_rules : [
      for sg in ingress_rule.source_security_group_ids : {
        from_port   = ingress_rule.from_port
        to_port     = ingress_rule.to_port
        protocol    = ingress_rule.protocol
        description = ingress_rule.description
        sg_id       = sg
      }
    ]
  ])

  egress_rules_expanded = flatten([
    for rule in var.egress_rules : [
      for cidr in rule.cidr_blocks : {
        from_port   = rule.from_port
        to_port     = rule.to_port
        protocol    = rule.protocol
        cidr_block  = cidr
        description = rule.description
      }
    ]
  ])

  referenced_egress_rules_expanded = flatten([
    for egress_rule in var.egress_rules : [
      for sg in egress_rule.source_security_group_ids : {
        from_port   = egress_rule.from_port
        to_port     = egress_rule.to_port
        protocol    = egress_rule.protocol
        description = egress_rule.description
        sg_id       = sg
      }
    ]
  ])
}