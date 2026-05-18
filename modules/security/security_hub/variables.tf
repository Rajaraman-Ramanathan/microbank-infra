variable "enable_default_standards" {
  type    = bool
  default = false
}

variable "enable_org_configuration" {
  type    = bool
  default = false
}

variable "enable_inspector" {
  type    = bool
  default = false
}

variable "security_standards" {
  type    = list(string)
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}