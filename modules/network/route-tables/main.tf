resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  tags = merge(
    {
      Name = "${var.name}-public-rt"
    },
    var.tags
  )
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.igw_id
}

resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  tags = merge(
    {
      Name = "${var.name}-private-rt"
    },
    var.tags
  )
}

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat_id
}

resource "aws_route_table" "db" {
  vpc_id = var.vpc_id

  tags = merge(
    {
      Name = "${var.name}-db-rt"
    },
    var.tags
  )
}

resource "aws_route_table_association" "public" {
  for_each = toset(var.public_subnet_ids)

  subnet_id      = each.value
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  for_each = toset(var.private_subnet_ids)

  subnet_id      = each.value
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "db" {
  for_each = toset(var.db_subnet_ids)

  subnet_id      = each.value
  route_table_id = aws_route_table.db.id
}