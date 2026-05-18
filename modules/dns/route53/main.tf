resource "aws_route53_zone" "this" {
  name = var.domain_name
  comment = var.comment
  dynamic "vpc" {
    for_each = var.private_zone ? [1] : []
    content {
      vpc_id = var.vpc_id
    }
  }

  tags = merge(
    var.tags,
    {
      Name = var.domain_name
    }
  )
}

resource "aws_route53_record" "this" {
  for_each = local.dns_records
  zone_id = aws_route53_zone.this.zone_id
  name = each.value.name
  type = each.value.type
  ttl = try(each.value.ttl, null)
  records = try(each.value.records, null)
  dynamic "alias" {
  for_each = each.value.alias_list
  content {
    name                   = alias.value.name
    zone_id                = alias.value.zone_id
    evaluate_target_health = alias.value.evaluate_target_health
    }
  }
}