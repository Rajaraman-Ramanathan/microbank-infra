data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_provider_url, "https://", "")}:sub"

      values = [
        "system:serviceaccount:${var.namespace}:${var.service_account}"
      ]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = "${var.cluster_name}-${var.namespace}-${var.service_account}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = toset(var.policy_arns)

  role       = aws_iam_role.this.name
  policy_arn = each.value
}