variable "name" {
  type = string
}

variable "description" {
  type = string
}

variable "kms_key_arn" {
  type = string
}

variable "recovery_window_in_days" {
  type    = number
  default = 30
}

variable "secret_string" {
  type    = string
  default = null

  sensitive = true
}

variable "secret_map" {
  type    = map(string)
  default = {}

  sensitive = true
}

variable "enable_resource_policy" {
  type    = bool
  default = false
}

variable "allowed_principals" {
  type    = list(string)
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}