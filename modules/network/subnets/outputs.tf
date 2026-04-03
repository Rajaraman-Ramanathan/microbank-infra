output "public_subnet_ids" {
  value = values(aws_subnet.public)[*].id
}

output "private_subnet_ids" {
  value = values(aws_subnet.private)[*].id
}

output "db_subnet_ids" {
  value = values(aws_subnet.db)[*].id
}