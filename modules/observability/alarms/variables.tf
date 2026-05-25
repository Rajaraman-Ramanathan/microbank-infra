variable "name" {
  type = string
}

variable "kms_key_arn" {
  type = string
}

variable "subscriptions" {
  type = list(object({
    protocol = string
    endpoint = string
  }))
  default = []
}

variable "alarms" {
  type = list(object({
    name = string
    namespace = string
    metric_name = string
    statistic = string
    threshold = number
    comparison_operator = string
    evaluation_periods = number
    period = number
    dimensions = optional(map(string))
    description = optional(string)
    treat_missing_data = optional(string)
  }))
}

variable "tags" {
  type    = map(string)
  default = {}
}