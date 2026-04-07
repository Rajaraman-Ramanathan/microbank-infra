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
  description = "List of public subnet CIDRs"
  type = list(string)
  validation {
    condition     = length(var.public_subnet_cidrs) == length(var.azs)
    error_message = "public subnet CIDR count must match AZ count"
  }
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDRs"
  type = list(string)
  validation {
    condition     = length(var.private_subnet_cidrs) == length(var.azs)
    error_message = "private subnet CIDR count must match AZ count"
  }
}

variable "db_subnet_cidrs" {
  description = "List of database subnet CIDRs"
  type = list(string)
  validation {
    condition     = length(var.db_subnet_cidrs) == length(var.azs)
    error_message = "database subnet CIDR count must match AZ count"
  }
}

variable "cluster_name" {
  description = "EKS cluster name (for tagging)"
  type = string
}

variable "tags" {
  description = "Common tags"
  type = map(string)
}