variable "name" {
  description = "Name of the security group"
  type        = string
}

variable "description" {
  description = "Description of the security group"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the security group will be created"
  type        = string
}

variable "ingress_rules" {
  description = "List of ingress rules"
  type = list(object({
    from_port                 = number
    to_port                   = number
    protocol                  = string
    description               = string
    cidr_blocks               = optional(list(string), [])
    source_security_group_ids = optional(list(string), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.ingress_rules :
      length(rule.cidr_blocks) > 0 || length(rule.source_security_group_ids) > 0
    ])
    error_message = "Each rule must define at least one CIDR block or source security group."
  }
}

variable "egress_rules" {
  description = "List of egress rules"
  type = list(object({
    from_port                 = number
    to_port                   = number
    protocol                  = string
    description               = string
    cidr_blocks               = optional(list(string), [])
    source_security_group_ids = optional(list(string), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.egress_rules :
      length(rule.cidr_blocks) > 0 || length(rule.source_security_group_ids) > 0
    ])
    error_message = "Each rule must define at least one CIDR block or source security group."
  }
}

variable "tags" {
  description = "Tags for the security group"
  type        = map(string)
  default     = {}
}