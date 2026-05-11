data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "kms" {

  # Root admin access
  statement {
    sid    = "EnableRootPermissions"
    effect = "Allow"

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }

    actions = [
      "kms:*"
    ]

    resources = ["*"]
  }

  # Optional additional admins
  dynamic "statement" {
    for_each = length(var.admin_principals) > 0 ? [1] : []

    content {
      sid    = "AllowKeyAdmins"
      effect = "Allow"

      principals {
        type        = "AWS"
        identifiers = var.admin_principals
      }

      actions = [
        "kms:Describe*",
        "kms:Get*",
        "kms:List*",
        "kms:Put*",
        "kms:Update*",
        "kms:Enable*",
        "kms:Disable*",
        "kms:ScheduleKeyDeletion",
        "kms:CancelKeyDeletion"
      ]

      resources = ["*"]
    }
  }

  # Optional usage principals
  dynamic "statement" {
    for_each = length(var.usage_principals) > 0 ? [1] : []

    content {
      sid    = "AllowKeyUsage"
      effect = "Allow"

      principals {
        type        = "AWS"
        identifiers = var.usage_principals
      }

      actions = [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:GenerateDataKey",
        "kms:DescribeKey"
      ]

      resources = ["*"]
    }
  }
}

resource "aws_kms_key" "this" {
  description             = var.description
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = true
  policy = data.aws_iam_policy_document.kms.json

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}

resource "aws_kms_alias" "this" {
  name          = "alias/${var.name}"
  target_key_id = aws_kms_key.this.key_id
}