resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    local.tags,
    {
      Name = "${var.platform}-${var.environment}-igw"
    }
  )
}

resource "aws_eip" "nat" {
  count = length(var.public_subnet_cidrs)

  tags = merge(
    local.tags,
    {
      Name = "${var.platform}-${var.environment}-nat-eip-${var.availability_zones[count.index]}"
    }
  )
}

resource "aws_nat_gateway" "this" {
  count         = length(var.public_subnet_cidrs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  depends_on = [aws_internet_gateway.this]

  tags = merge(
    local.tags,
    {
      Name = "${var.platform}-${var.environment}-nat-gw-${var.availability_zones[count.index]}"
    }
  )
}