variable "vpc_id" {
  description = "value of the VPC ID to which the route tables will be associated"
  type = string
}

variable "igw_id" {
  description = "value of the Internet Gateway ID to be used in the route tables"
  type = string
}

variable "nat_id" {
  description = "value of the NAT Gateway ID to be used in the route tables"
  type = string
}

variable "public_subnet_ids" {
  description = "list of public subnet IDs to be associated with the public route table"
  type = list(string)
}

variable "private_subnet_ids" {
  description = "list of private subnet IDs to be associated with the private route table"
  type = list(string)
}

variable "db_subnet_ids" {
  description = "list of database subnet IDs to be associated with the database route table"
  type = list(string)
}

variable "name" {
  description = "name of the route table"
  type = string
}

variable "tags" {
  description = "tags to assign to the route table"
  type = map(string)
}