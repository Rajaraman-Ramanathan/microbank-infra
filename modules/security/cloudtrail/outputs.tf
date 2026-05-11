output "trail_arn" {
  value = aws_cloudtrail.this.arn
}

output "trail_name" {
  value = aws_cloudtrail.this.name
}

output "cloudwatch_log_group_name" {
  value = aws_cloudwatch_log_group.this.name
}