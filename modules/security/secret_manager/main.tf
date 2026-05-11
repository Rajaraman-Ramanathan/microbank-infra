data "aws_iam_policy_document" "secret" {
  count = var.enable_resource_policy ? 1 : 0
  statement {
    sid    = "AllowSecretAccess"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = var.allowed_principals
    }

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]

    resources = [
      aws_secretsmanager_secret.this.arn
    ]
  }
}

resource "aws_secretsmanager_secret" "this" {
  name                    = var.name
  description             = var.description
  kms_key_id              = var.kms_key_arn
  recovery_window_in_days = var.recovery_window_in_days

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id = aws_secretsmanager_secret.this.id
  secret_string = (
    var.secret_string != null
    ? var.secret_string
    : jsonencode(var.secret_map)
  )
}

resource "aws_secretsmanager_secret_policy" "this" {
  count = var.enable_resource_policy ? 1 : 0
  secret_arn = aws_secretsmanager_secret.this.arn
  policy = data.aws_iam_policy_document.secret[0].json
}