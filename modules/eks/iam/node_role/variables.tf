variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

variable "cluster_name" {
  description = "EKS cluster name"
  type = string
}