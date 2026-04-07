variable "name" {
  description = "Name of the VPC"
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for VPC"
  type        = string
}

variable "enable_dns_support" {
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  type        = bool
  default     = true
}

variable "enable_flow_logs" {
  description = "Enable VPC Flow Logs"
  type        = bool
  default     = true
}

variable "flow_logs_destination_type" {
  description = "cloud-watch-logs or s3"
  type        = string
  default     = "cloud-watch-logs"
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}