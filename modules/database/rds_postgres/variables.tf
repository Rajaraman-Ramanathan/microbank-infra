variable "name" {
  description = "RDS instance identifier"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "db_subnet_ids" {
  description = "Private database subnet IDs"
  type        = list(string)
}

variable "kms_key_arn" {
  description = "KMS key ARN for encryption"
  type        = string
}

variable "master_username" {
  description = "Master database username"
  type        = string
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "engine_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "17.5"
}

variable "parameter_group_family" {
  description = "PostgreSQL parameter group family"
  type        = string
  default     = "postgres17"
}

variable "allocated_storage" {
  description = "Initial storage allocation in GB"
  type        = number
  default     = 100
}

variable "max_allocated_storage" {
  description = "Maximum autoscaling storage in GB"
  type        = number
  default     = 500
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = true
}

variable "backup_retention_period" {
  description = "Backup retention period"
  type        = number
  default     = 35
}

variable "monitoring_interval" {
  description = "Enhanced monitoring interval"
  type        = number
  default     = 60
}

variable "log_retention_days" {
  description = "CloudWatch log retention"
  type        = number
  default     = 90
}

variable "ca_cert_identifier" {
  description = "RDS CA certificate"
  type        = string
  default     = "rds-ca-rsa2048-g1"
}

variable "storage_throughput" {
  type    = number
  default = 250
}

variable "enabled_cloudwatch_logs_exports" {
  type = list(string)

  default = [
    "postgresql"
  ]
}

variable "security_group_id" {
  type = string
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}