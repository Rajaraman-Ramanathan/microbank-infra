locals {
  log_groups = {
    for lg in var.log_groups :
    lg.name => lg
  }

  metric_filters = {
    for mf in var.metric_filters :
    mf.name => mf
  }
}