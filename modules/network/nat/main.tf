resource "aws_eip" "this" {
  domain = "vpc"

  tags = var.tags
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = var.public_subnet_id

  tags = merge(
    {
      Name = "${var.name}-nat"
    },
    var.tags
  )
}