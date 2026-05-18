data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "config_assume" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "config_s3" {

  statement {
    sid = "AWSConfigBucketPermissionsCheck"

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions = [
      "s3:GetBucketAcl"
    ]

    resources = [
      var.s3_bucket_arn
    ]
  }

  statement {
    sid = "AWSConfigBucketDelivery"

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${var.s3_bucket_arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/Config/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"

      values = [
        "bucket-owner-full-control"
      ]
    }
  }
}

resource "aws_iam_role" "config" {
  name = "${var.name}-config-role"
  assume_role_policy = data.aws_iam_policy_document.config_assume.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "config" {
  role = aws_iam_role.config.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}

resource "aws_s3_bucket_policy" "config" {
  bucket = var.s3_bucket_name
  policy = data.aws_iam_policy_document.config_s3.json
}

resource "aws_config_configuration_recorder" "this" {
  name = "${var.name}-recorder"
  role_arn = aws_iam_role.config.arn

  recording_group {
    all_supported = true
    include_global_resource_types = var.include_global_resources
    recording_strategy {
      use_only = "ALL_SUPPORTED_RESOURCE_TYPES"
    }
  }
}

resource "aws_config_delivery_channel" "this" {
  name = "${var.name}-delivery"
  s3_bucket_name = var.s3_bucket_name
  s3_kms_key_arn = var.kms_key_arn
  snapshot_delivery_properties {
    delivery_frequency = var.delivery_frequency
  }
}

resource "aws_config_configuration_recorder_status" "this" {
  name = aws_config_configuration_recorder.this.name
  is_enabled = true

  depends_on = [
    aws_config_delivery_channel.this
  ]
}