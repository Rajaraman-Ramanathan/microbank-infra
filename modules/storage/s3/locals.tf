locals {
  lifecycle_rules_final = (
    length(var.lifecycle_rules) > 0
    ? var.lifecycle_rules
    : [
        {
          id      = "expire-old-objects"
          enabled = true

          expiration = {
            days = 90
          }
        }
      ]
  )
}