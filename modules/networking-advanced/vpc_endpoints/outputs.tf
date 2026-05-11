output "gateway_endpoint_ids" {
  value = {
    for k, v in aws_vpc_endpoint.gateway :
    k => v.id
  }
}

output "interface_endpoint_ids" {
  value = {
    for k, v in aws_vpc_endpoint.interface :
    k => v.id
  }
}

output "security_group_id" {
  value = aws_security_group.vpce.id
}