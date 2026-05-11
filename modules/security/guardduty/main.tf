resource "aws_guardduty_detector" "this" {
  enable = true
  finding_publishing_frequency = var.finding_publishing_frequency

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}

resource "aws_guardduty_detector_feature" "s3_protection" {
  detector_id = aws_guardduty_detector.this.id
  name   = "S3_DATA_EVENTS"
  status = "ENABLED"
}

resource "aws_guardduty_detector_feature" "eks_audit" {
  detector_id = aws_guardduty_detector.this.id
  name   = "EKS_AUDIT_LOGS"
  status = "ENABLED"
}

resource "aws_guardduty_detector_feature" "eks_runtime" {
  detector_id = aws_guardduty_detector.this.id
  name   = "EKS_RUNTIME_MONITORING"
  status = "ENABLED"
}

resource "aws_guardduty_detector_feature" "malware_protection" {
  detector_id = aws_guardduty_detector.this.id
  name   = "EBS_MALWARE_PROTECTION"
  status = "ENABLED"
}