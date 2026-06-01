variable "name" {
  type = string
}

variable "kms_key_arn" {
  type = string
}

variable "backup_schedule" {
  type    = string
  default = "cron(0 2 * * ? *)"
}

variable "retention_days" {
  type    = number
  default = 35
}

variable "backup_tag_key" {
  type    = string
  default = "Backup"
}

variable "backup_tag_value" {
  type    = string
  default = "true"
}

variable "tags" {
  type    = map(string)
  default = {}
}