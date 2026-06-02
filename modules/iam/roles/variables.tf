variable "name" {
  type = string
}

variable "assume_role_policy" {
  type = string
}

variable "policy_arns" {
  type    = list(string)
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}