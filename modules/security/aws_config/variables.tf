variable "name" {
  type = string
}

variable "s3_bucket_name" {
  type = string
}

variable "s3_bucket_arn" {
  type = string
}

variable "kms_key_arn" {
  type = string
}

variable "include_global_resources" {
  type    = bool
  default = true
}

variable "delivery_frequency" {
  type    = string
  default = "TwentyFour_Hours"
}

variable "tags" {
  type    = map(string)
  default = {}
}