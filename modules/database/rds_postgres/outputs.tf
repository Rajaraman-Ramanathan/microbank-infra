output "endpoint" {
  value = aws_db_instance.this.endpoint
}

output "port" {
  value = aws_db_instance.this.port
}

output "security_group_id" {
  value = aws_security_group.rds.id
}

output "master_secret_arn" {
  value = aws_secretsmanager_secret.master.arn
}

output "address" {
  value = aws_db_instance.this.address
}

output "db_instance_identifier" {
  value = aws_db_instance.this.identifier
}