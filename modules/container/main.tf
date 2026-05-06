data "aws_iam_policy_document" "ecr_repository" {
  count = var.enable_repository_policy ? 1 : 0

  # Pull Access
  statement {
    sid    = "AllowPull"
    effect = "Allow"
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability"
    ]
    principals {
      type        = "AWS"
      identifiers = var.pull_principals
    }
  }

  # Push Access
  statement {
  sid    = "AllowPush"
  effect = "Allow"
  actions = [
    "ecr:PutImage",
    "ecr:InitiateLayerUpload",
    "ecr:UploadLayerPart",
    "ecr:CompleteLayerUpload"
  ]
  principals {
    type        = "AWS"
    identifiers = var.push_principals
  }
}
}

resource "aws_ecr_repository_policy" "this" {
  count = var.enable_repository_policy ? 1 : 0
  repository = aws_ecr_repository.this.name
  policy     = data.aws_iam_policy_document.ecr_repository[0].json
}

resource "aws_ecr_repository" "this" {
  name                 = var.name
  image_tag_mutability = var.image_tag_mutability
  image_scanning_configuration {
    scan_on_push = true
  }
  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = var.kms_key_arn
  }

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}

resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name

  policy = jsonencode({
  rules = local.ecr_lifecycle_rules
})
}