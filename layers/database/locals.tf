locals {
  common_tags = {
    Environment = "prod"
    Project     = "microbank"
  }
  backup_window = "02:00-03:00"
  maintenance_window = "sun:03:00-sun:04:00"
}