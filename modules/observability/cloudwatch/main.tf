resource "aws_cloudwatch_log_group" "this" {
  for_each = local.log_groups
  name = each.value.name
  retention_in_days = each.value.retention_days
  kms_key_id = var.kms_key_arn

  tags = merge(
    var.tags,
    {
      Name = each.value.name
    }
  )
}

resource "aws_cloudwatch_log_metric_filter" "this" {
  for_each = local.metric_filters
  name = each.value.name
  log_group_name = aws_cloudwatch_log_group.this[each.value.log_group].name
  pattern = each.value.pattern
  metric_transformation {
    name      = each.value.metric_name
    namespace = each.value.namespace
    value     = "1"
  }
}