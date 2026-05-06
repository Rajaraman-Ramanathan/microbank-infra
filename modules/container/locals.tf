locals {
  ecr_lifecycle_rules = (
    length(var.lifecycle_rules) > 0
    ? var.lifecycle_rules
    : [
        {
          rulePriority = 1
          description  = "Expire old images"

          selection = {
            tagStatus   = "any"
            countType   = "imageCountMoreThan"
            countNumber = var.max_image_count
          }

          action = {
            type = "expire"
          }
        }
      ]
  )
}