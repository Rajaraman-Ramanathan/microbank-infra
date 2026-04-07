variable "public_subnet_id" {
  description = "value of the public subnet ID where the NAT Gateway will be deployed"
  type = string
}

variable "name" {
  description = "name of the NAT Gateway"
  type = string
}

variable "tags" {
  description = "tags to assign to the NAT Gateway"
  type = map(string)
}