data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy_document" "cloudtrail_assume" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "cloudtrail_logs" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "${aws_cloudwatch_log_group.this.arn}:*"
    ]
  }
}

data "aws_iam_policy_document" "cloudtrail_s3" {
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = [
      "s3:GetBucketAcl"
    ]

    resources = [
      var.s3_bucket_arn
    ]
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${var.s3_bucket_arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values = ["bucket-owner-full-control"]
    }
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/cloudtrail/${var.name}"
  retention_in_days = var.log_retention_days
  kms_key_id        = var.kms_key_arn

  tags = var.tags
}

resource "aws_iam_role" "cloudtrail" {
  name = "${var.name}-cloudtrail-role"
  assume_role_policy = data.aws_iam_policy_document.cloudtrail_assume.json

  tags = var.tags
}

resource "aws_iam_policy" "cloudtrail_logs" {
  name   = "${var.name}-cloudtrail-logs-policy"
  policy = data.aws_iam_policy_document.cloudtrail_logs.json
}

resource "aws_iam_role_policy_attachment" "cloudtrail_logs" {
  role       = aws_iam_role.cloudtrail.name
  policy_arn = aws_iam_policy.cloudtrail_logs.arn
}

resource "aws_s3_bucket_policy" "cloudtrail" {
  bucket = var.s3_bucket_name
  policy = data.aws_iam_policy_document.cloudtrail_s3.json
}

resource "aws_cloudtrail" "this" {
  name = var.name
  s3_bucket_name = var.s3_bucket_name
  include_global_service_events = true
  is_multi_region_trail = true
  enable_log_file_validation = true
  kms_key_id = var.kms_key_arn
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.this.arn}:*"
  cloud_watch_logs_role_arn = aws_iam_role.cloudtrail.arn
  enable_logging = true

  tags = var.tags
}

