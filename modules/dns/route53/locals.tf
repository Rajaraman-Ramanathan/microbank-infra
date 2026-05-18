locals {
  dns_records = {
    for record in var.records :
    "${record.name}-${record.type}" => merge(
      record,
      {
        alias_list = (
          try(record.alias, null) != null
          ? [record.alias]
          : []
        )
      }
    )
  }
}