locals {
  common_tags = {
    Environment = "prod"
    Project     = "microbank"
  }
}

locals {
  alarms = [
    {
      name = "eks-node-cpu-high"
      namespace = "AWS/EC2"
      metric_name = "CPUUtilization"
      statistic = "Average"
      threshold = 80
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods = 2
      period = 300
      dimensions = {
        AutoScalingGroupName = "eks-platform-ng"
      }
      description = "EKS node CPU above 80%"
    },
    {
      name = "nat-gateway-bytes"
      namespace = "AWS/NATGateway"
      metric_name = "BytesOutToDestination"
      statistic = "Average"
      threshold = 100000000
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods = 2
      period = 300
      description = "High NAT traffic"
    },
    {
      name = "unauthorized-api-calls"
      namespace = "Security"
      metric_name = "UnauthorizedAPICalls"
      statistic = "Sum"
      threshold = 5
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods = 1
      period = 300
      description = "Unauthorized API calls"
    }
  ]
}