variable "name" {
  type = string
}

variable "description" {
  type = string
}

variable "deletion_window_in_days" {
  type    = number
  default = 30
}

variable "admin_principals" {
  type    = list(string)
  default = []
}

variable "usage_principals" {
  type    = list(string)
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}