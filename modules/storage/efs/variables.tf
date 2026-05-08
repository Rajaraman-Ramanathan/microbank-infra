variable "name" {
  type = string
}

variable "kms_key_arn" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "private_subnet_cidr" {
  type = string
}

variable "performance_mode" {
  type    = string
  default = "generalPurpose"
}

variable "throughput_mode" {
  type    = string
  default = "bursting"
}

variable "create_access_point" {
  type    = bool
  default = true
}

variable "root_directory_path" {
  type    = string
  default = "/data"
}

variable "posix_uid" {
  type    = number
  default = 1000
}

variable "posix_gid" {
  type    = number
  default = 1000
}

variable "tags" {
  type    = map(string)
  default = {}
}