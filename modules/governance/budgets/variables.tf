variable "name" {
  type = string
}

variable "monthly_budget" {
  type = number
}

variable "notifications" {
  type = list(object({
    threshold = number
    notification_type = string
    emails = list(string)
  }))
}