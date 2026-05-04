variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
}

variable "service_account" {
  description = "Kubernetes service account name"
  type        = string
}

variable "oidc_provider_arn" {
  description = "OIDC provider ARN"
  type        = string
}

variable "oidc_provider_url" {
  description = "OIDC provider URL"
  type        = string
}

variable "policy_arns" {
  description = "List of IAM policies to attach"
  type        = list(string)
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}