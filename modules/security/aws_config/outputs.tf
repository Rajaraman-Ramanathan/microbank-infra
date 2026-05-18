output "recorder_name" {
  value = aws_config_configuration_recorder.this.name
}

output "role_arn" {
  value = aws_iam_role.config.arn
}