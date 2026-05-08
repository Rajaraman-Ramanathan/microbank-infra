variable "bucket_name" {
  type = string
}

variable "kms_key_arn" {
  type = string
}

variable "force_destroy" {
  type    = bool
  default = false
}

variable "versioning_enabled" {
  type    = bool
  default = true
}

variable "enable_bucket_policy" {
  type    = bool
  default = false
}

variable "allowed_principals" {
  type    = list(string)
  default = []
}

variable "lifecycle_rules" {
  type    = list(any)
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}