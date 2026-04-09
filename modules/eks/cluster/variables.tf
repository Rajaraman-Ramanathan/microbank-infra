variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "cluster_security_group_id" {
  type = string
}

variable "cluster_role_arn" {
  type = string
}

variable "endpoint_private_access" {
  type    = bool
  default = true
}

variable "endpoint_public_access" {
  type    = bool
  default = false
}

variable "kms_key_arn" {
  type = string
}

variable "tags" {
  type = map(string)
}