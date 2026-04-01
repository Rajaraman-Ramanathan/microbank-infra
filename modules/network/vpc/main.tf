resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}

# -----------------------------
# Flow Logs (Enterprise MUST)
# -----------------------------

resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  count = var.enable_flow_logs && var.flow_logs_destination_type == "cloud-watch-logs" ? 1 : 0

  name              = "/aws/vpc/${var.name}/flow-logs"
  retention_in_days = 30

  tags = var.tags
}

resource "aws_iam_role" "flow_logs_role" {
  count = var.enable_flow_logs && var.flow_logs_destination_type == "cloud-watch-logs" ? 1 : 0

  name = "${var.name}-vpc-flow-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "vpc-flow-logs.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "flow_logs_policy" {
  count = var.enable_flow_logs && var.flow_logs_destination_type == "cloud-watch-logs" ? 1 : 0

  name = "${var.name}-flow-logs-policy"
  role = aws_iam_role.flow_logs_role[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_flow_log" "this" {
  count = var.enable_flow_logs ? 1 : 0

  log_destination_type = var.flow_logs_destination_type
  log_destination      = var.flow_logs_destination_type == "cloud-watch-logs" ? aws_cloudwatch_log_group.vpc_flow_logs[0].arn : null

  iam_role_arn = var.flow_logs_destination_type == "cloud-watch-logs" ? aws_iam_role.flow_logs_role[0].arn : null

  vpc_id = aws_vpc.this.id
  traffic_type = "ALL"

  tags = var.tags
}