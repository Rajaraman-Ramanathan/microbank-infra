locals {
  create_flow_logs = var.enable_flow_logs && var.flow_logs_destination_type == "cloud-watch-logs"
  flow_logs_map = local.create_flow_logs ? { enabled = true } : {}
}