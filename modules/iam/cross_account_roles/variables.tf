variable "name" {
  type = string
}

variable "trusted_account_arn" {
  type = string
}

variable "policy_arns" {
  type    = list(string)
  default = []
}

variable "description" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}