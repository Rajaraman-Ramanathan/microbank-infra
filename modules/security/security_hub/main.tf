data "aws_region" "current" {}

resource "aws_securityhub_account" "this" {
  enable_default_standards = var.enable_default_standards
}

resource "aws_securityhub_organization_configuration" "this" {
  count = var.enable_org_configuration ? 1 : 0
  auto_enable = true
}

resource "aws_securityhub_standards_subscription" "this" {
  for_each = toset(local.security_standards)
  standards_arn = "arn:aws:securityhub:${data.aws_region.current.name}::standards/${each.value}"
}

resource "aws_securityhub_product_subscription" "guardduty" {
  product_arn = "arn:aws:securityhub:${data.aws_region.current.name}::product/aws/guardduty"

  depends_on = [
    aws_securityhub_account.this
  ]
}

resource "aws_securityhub_product_subscription" "inspector" {
  count = var.enable_inspector ? 1 : 0
  product_arn = "arn:aws:securityhub:${data.aws_region.current.name}::product/aws/inspector"

  depends_on = [
    aws_securityhub_account.this
  ]
}