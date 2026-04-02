data "aws_iam_policy_document" "flow_logs_assume" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy_document" "flow_logs_permissions" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/vpc/${var.name}:*"]
  }
}

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
  for_each = local.flow_logs_map
  name              = "/aws/vpc/${var.name}/flow-logs"
  retention_in_days = 30
  tags = var.tags
}

resource "aws_iam_role" "flow_logs_role" {
  for_each = local.flow_logs_map
  name               = "${var.name}-vpc-flow-logs-role"
  assume_role_policy = data.aws_iam_policy_document.flow_logs_assume["enabled"].json
  tags = var.tags
}

resource "aws_iam_policy" "flow_logs_policy" {
  for_each = local.flow_logs_map
  name   = "${var.name}-flow-logs-policy"
  policy = data.aws_iam_policy_document.flow_logs_permissions["enabled"].json
}

resource "aws_iam_role_policy_attachment" "flow_logs_attach" {
  for_each = local.flow_logs_map
  role       = aws_iam_role.flow_logs_role["enabled"].name
  policy_arn = aws_iam_policy.flow_logs_policy["enabled"].arn
}

resource "aws_flow_log" "this" {
  for_each = local.flow_logs_map
  vpc_id = aws_vpc.this.id
  traffic_type = "ALL"
  log_destination_type = "cloud-watch-logs"
  log_destination = aws_cloudwatch_log_group.vpc_flow_logs["enabled"].arn
  iam_role_arn = aws_iam_role.flow_logs_role["enabled"].arn
  tags = var.tags
}