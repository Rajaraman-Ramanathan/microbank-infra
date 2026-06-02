data "aws_iam_policy_document" "assume" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "AWS"
      identifiers = [
        var.trusted_account_arn
      ]
    }
  }
}

resource "aws_iam_role" "this" {
  name = var.name
  description = var.description
  assume_role_policy = data.aws_iam_policy_document.assume.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = toset(var.policy_arns)
  role = aws_iam_role.this.name
  policy_arn = each.value
}