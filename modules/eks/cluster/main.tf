resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids = var.private_subnet_ids

    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access

    # Use SG from your reusable SG module
    security_group_ids = [var.cluster_security_group_id]
  }

  # -----------------------------
  # Control Plane Logging
  # -----------------------------
  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  # -----------------------------
  # Encryption (MANDATORY)
  # -----------------------------
  encryption_config {
    provider {
      key_arn = var.kms_key_arn
    }
    resources = ["secrets"]
  }

  tags = merge(
    var.tags,
    {
      Name = var.cluster_name
    }
  )

  depends_on = [
    var.cluster_role_arn
  ]
}