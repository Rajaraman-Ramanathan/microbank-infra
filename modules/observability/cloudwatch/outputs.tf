output "log_group_names" {
  value = [
    for lg in aws_cloudwatch_log_group.this :
    lg.name
  ]
}

output "log_group_arns" {
  value = [
    for lg in aws_cloudwatch_log_group.this :
    lg.arn
  ]
}