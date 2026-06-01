data "aws_iam_policy_document" "backup_assume" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"

      identifiers = [
        "backup.amazonaws.com"
      ]
    }
  }
}

resource "aws_backup_vault" "this" {
  name = "${var.name}-vault"
  kms_key_arn = var.kms_key_arn

  tags = var.tags
}

resource "aws_iam_role" "backup" {
  name = "${var.name}-backup-role"
  assume_role_policy = data.aws_iam_policy_document.backup_assume.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "backup" {
  role = aws_iam_role.backup.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}

resource "aws_backup_plan" "this" {
  name = "${var.name}-backup-plan"

  rule {
    rule_name = "daily-backup"
    target_vault_name = aws_backup_vault.this.name
    schedule = var.backup_schedule

    lifecycle {
      delete_after = var.retention_days
    }
  }

  tags = var.tags
}

resource "aws_backup_selection" "this" {
  name = "${var.name}-selection"
  iam_role_arn = aws_iam_role.backup.arn
  plan_id = aws_backup_plan.this.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = var.backup_tag_key
    value = var.backup_tag_value
  }
}