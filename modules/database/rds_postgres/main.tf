data "aws_iam_policy_document" "rds_monitoring_assume" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"

      identifiers = [
        "monitoring.rds.amazonaws.com"
      ]
    }
  }
}

resource "aws_security_group" "rds" {
  name        = "${var.name}-rds-sg"
  description = "RDS PostgreSQL Security Group"
  vpc_id      = var.vpc_id

  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "postgres" {
  for_each = toset(var.allowed_security_group_ids)
  security_group_id = aws_security_group.rds.id
  referenced_security_group_id = each.value
  from_port   = 5432
  to_port     = 5432
  ip_protocol = "tcp"
  description = "PostgreSQL access"
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.rds.id
  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
  description = "Allow all outbound traffic"
}

resource "aws_db_subnet_group" "this" {
  name = "${var.name}-db-subnet-group"
  subnet_ids = var.db_subnet_ids

  tags = var.tags
}

resource "aws_db_parameter_group" "this" {
  name   = "${var.name}-postgres"
  family = var.parameter_group_family

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name  = "log_disconnections"
    value = "1"
  }

  tags = var.tags
}

resource "aws_iam_role" "enhanced_monitoring" {
  name = "${var.name}-rds-monitoring-role"
  assume_role_policy = data.aws_iam_policy_document.rds_monitoring_assume.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "monitoring" {
  role = aws_iam_role.enhanced_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

resource "random_password" "master" {
  length  = 32
  special = true
}

resource "aws_secretsmanager_secret" "master" {
  name = "${var.name}-postgres-master"
  kms_key_id = var.kms_key_arn

  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "master" {
  secret_id = aws_secretsmanager_secret.master.id

  secret_string = jsonencode({
    username = var.master_username
    password = random_password.master.result
  })
}

resource "aws_cloudwatch_log_group" "postgresql" {
  name = "/aws/rds/instance/${var.name}/postgresql"
  retention_in_days = var.log_retention_days
  kms_key_id = var.kms_key_arn

  tags = var.tags
}

resource "aws_db_instance" "this" {
  identifier = var.name
  engine         = "postgres"
  engine_version = var.engine_version
  instance_class = var.instance_class
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type      = "gp3"
  storage_encrypted = true
  kms_key_id = var.kms_key_arn
  username = var.master_username
  password = random_password.master.result
  db_subnet_group_name = aws_db_subnet_group.this.name

  vpc_security_group_ids = [
    aws_security_group.rds.id
  ]

  multi_az = var.multi_az
  backup_retention_period = var.backup_retention_period
  backup_window = "03:00-04:00"
  maintenance_window = "Sun:04:00-Sun:05:00"
  performance_insights_enabled = true
  performance_insights_kms_key_id = var.kms_key_arn
  monitoring_interval = var.monitoring_interval
  monitoring_role_arn = aws_iam_role.enhanced_monitoring.arn

  enabled_cloudwatch_logs_exports = [
    "postgresql"
  ]

  deletion_protection = true
  copy_tags_to_snapshot = true
  auto_minor_version_upgrade = true
  apply_immediately = false
  parameter_group_name = aws_db_parameter_group.this.name
  ca_cert_identifier = var.ca_cert_identifier
  network_type = "IPV4"
  skip_final_snapshot = false
  final_snapshot_identifier = "${var.name}-final-snapshot"

  tags = var.tags

  depends_on = [
    aws_cloudwatch_log_group.postgresql
  ]

  lifecycle {
    prevent_destroy = true
  }
}