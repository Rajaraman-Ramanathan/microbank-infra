variable "name" {
  description = "ECR repository name"
  type        = string
}

variable "image_tag_mutability" {
  description = "IMMUTABLE or MUTABLE"
  type        = string
  default     = "IMMUTABLE"
}

variable "kms_key_arn" {
  description = "KMS key for encryption"
  type        = string
}

variable "max_image_count" {
  description = "Max images to retain"
  type        = number
  default     = 50
}

variable "enable_repository_policy" {
  type    = bool
  default = false
}

variable "pull_principals" {
  type    = list(string)
  default = []
}

variable "push_principals" {
  type    = list(string)
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "lifecycle_rules" {
  description = "Custom lifecycle rules"
  type        = list(any)
  default     = []
}