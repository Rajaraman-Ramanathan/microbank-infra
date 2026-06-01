resource "aws_wafv2_web_acl" "this" {
  name  = var.name
  scope = "REGIONAL"
  description = "Enterprise WAF for ALB"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name = var.name
    sampled_requests_enabled = true
  }

    dynamic "rule" {
    for_each = local.managed_rules
    
    content {
      name     = rule.key
      priority = rule.value.priority
      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          vendor_name = "AWS"
          name = rule.key
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name = rule.key
        sampled_requests_enabled = true
      }
    }
  }

    rule {
    name     = "RateLimit"
    priority = 100

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = var.rate_limit
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name = "RateLimit"
      sampled_requests_enabled = true
    }
  }

    tags = var.tags
}

resource "aws_wafv2_web_acl_association" "alb" {
  count = var.alb_arn != null ? 1 : 0
  resource_arn = var.alb_arn
  web_acl_arn = aws_wafv2_web_acl.this.arn
}

