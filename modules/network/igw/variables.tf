variable "vpc_id" {
  description = "value of the VPC ID to which the Internet Gateway will be attached"
  type = string
}

variable "name" {
  description = "name of the Internet Gateway"
  type = string
}

variable "tags" {
  description = "value of the tags to assign to the Internet Gateway"
  type = map(string)
}