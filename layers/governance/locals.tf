locals {

  budget_notifications = [
    {
      threshold = 80
      notification_type = "ACTUAL"
      emails = ["platform-team@microbank.com"]
    },
    {
      threshold = 90
      notification_type = "ACTUAL"
      emails = ["platform-team@microbank.com"]
    },
    {
      threshold = 100
      notification_type = "FORECASTED"
      emails = ["platform-team@microbank.com"]
    }
  ]
}