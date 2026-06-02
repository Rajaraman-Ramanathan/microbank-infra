variable "name" {
  type = string
}

variable "description" {
  type    = string
  default = null
}

variable "policy_json" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}