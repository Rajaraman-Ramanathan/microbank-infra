variable "name" {
  description = "Base name for resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

# Fixed CIDR inputs (your choice)
variable "public_subnet_cidrs" {
  type = list(string)
  validation {
    condition     = length(var.public_subnet_cidrs) == length(var.azs)
    error_message = "CIDR count must match AZ count"
  }
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "db_subnet_cidrs" {
  type = list(string)
}

variable "cluster_name" {
  description = "EKS cluster name (for tagging)"
  type        = string
}

variable "tags" {
  type = map(string)
}