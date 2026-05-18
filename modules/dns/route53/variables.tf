variable "domain_name" {
  type = string
}

variable "comment" {
  type    = string
  default = "Managed by Terraform"
}

variable "private_zone" {
  type    = bool
  default = false
}

variable "vpc_id" {
  type    = string
  default = null
}

variable "records" {
  type = list(object({
    name    = string
    type    = string
    ttl     = optional(number)
    records = optional(list(string))

    alias = optional(object({
      name                   = string
      zone_id                = string
      evaluate_target_health = bool
    }))
  }))

  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}