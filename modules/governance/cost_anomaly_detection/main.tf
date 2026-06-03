resource "aws_ce_anomaly_monitor" "this" {
  name = var.name
  monitor_type = "DIMENSIONAL"
  monitor_dimension = "SERVICE"
  # monitor_dimension = "LINKED_ACCOUNT" for linked account monitoring
}

resource "aws_ce_anomaly_subscription" "this" {
  name = "${var.name}-subscription"
  frequency = "DAILY"

  monitor_arn_list = [
    aws_ce_anomaly_monitor.this.arn
  ]

  subscriber {
    type    = "EMAIL"
    address = var.email
  }

  threshold_expression {
    dimension {
      key = "ANOMALY_TOTAL_IMPACT_ABSOLUTE"
      values = [
        tostring(var.threshold)
      ]
    }
  }
}