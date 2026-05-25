resource "aws_sns_topic" "alerts" {
  name = "${var.name}-alerts"
  kms_master_key_id = var.kms_key_arn

  tags = var.tags
}

resource "aws_sns_topic_subscription" "this" {
  for_each = {
    for s in var.subscriptions :
    s.endpoint => s
  }
  topic_arn = aws_sns_topic.alerts.arn
  protocol = each.value.protocol
  endpoint = each.value.endpoint
}

resource "aws_cloudwatch_metric_alarm" "this" {
  for_each = local.alarms
  alarm_name = each.value.name
  comparison_operator = each.value.comparison_operator
  evaluation_periods = each.value.evaluation_periods
  metric_name = each.value.metric_name
  namespace = each.value.namespace
  period = each.value.period
  statistic = each.value.statistic
  threshold = each.value.threshold
  alarm_description = try(each.value.description, null)
  dimensions = try(each.value.dimensions, null)

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]

  ok_actions = [
    aws_sns_topic.alerts.arn
  ]

  insufficient_data_actions = []
  treat_missing_data = try(each.value.treat_missing_data,"missing")

  tags = var.tags
}