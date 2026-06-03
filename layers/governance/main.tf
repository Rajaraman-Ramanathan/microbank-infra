module "budget" {
  source = "../../modules/governance/budgets"

  name = "microbank-budget"
  monthly_budget = 500

    notifications = [
    {
      threshold = 80
      notification_type = "ACTUAL"
      emails = [
        "platform-team@microbank.com"
      ]
    },
    {
      threshold = 90
      notification_type = "ACTUAL"
      emails = [
        "platform-team@microbank.com"
      ]
    },
    {
      threshold = 100
      notification_type = "FORECASTED"
      emails = [
        "platform-team@microbank.com"
      ]
    }
  ]
}

module "cost_anomaly_detection" {
  source = "../../modules/governance/cost_anomaly_detection"

  name = "microbank"
  email = "platform-team@microbank.com"
  threshold = 50
}