output "file_system_id" {
  value = aws_efs_file_system.this.id
}

output "file_system_arn" {
  value = aws_efs_file_system.this.arn
}

output "access_point_id" {
  value = try(aws_efs_access_point.this[0].id, null)
}

output "security_group_id" {
  value = aws_security_group.efs.id
}