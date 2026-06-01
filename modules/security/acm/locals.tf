locals {
  validation_records = {
    for dvo in aws_acm_certificate.this.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      value  = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
}