variable "external_dns_role_arn" {
  type = string
}

variable "txt_owner_id" {
  type = string
}

variable "domain_filters" {
  type = list(string)
}

variable "zone_type" {
  type    = string
  default = "public"
}

variable "policy" {
  type    = string
  default = "sync"
}