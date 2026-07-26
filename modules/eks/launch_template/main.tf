resource "aws_launch_template" "this" {
  name_prefix            = "${var.cluster_name}-nodes-"
  update_default_version = true

  vpc_security_group_ids = [
    var.node_security_group_id
  ]

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      var.tags,
      {
        Name = "${var.cluster_name}-node"
      }
    )
  }

  tags = var.tags
}