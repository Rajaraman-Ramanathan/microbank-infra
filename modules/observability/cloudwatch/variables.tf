variable "kms_key_arn" {
  type = string
}

variable "log_groups" {
  type = list(object({
    name = string
    retention_days = number
  }))
}

variable "metric_filters" {
  type = list(object({
    name = string
    log_group = string
    pattern = string
    metric_name = string
    namespace = string
  }))
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}