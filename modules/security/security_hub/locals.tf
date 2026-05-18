locals {
  security_standards = (
    length(var.security_standards) > 0
    ? var.security_standards
    : [
        "cis-aws-foundations-benchmark/v/1.2.0",
        "aws-foundational-security-best-practices/v/1.0.0"
      ]
  )
}