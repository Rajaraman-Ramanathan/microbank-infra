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
}