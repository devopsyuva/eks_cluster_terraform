resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = merge(
    local.common_tags,
    {
      Name = "public-route"
    }
  )
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = merge(
    local.common_tags,
    {
      Name = "private-route"
    }
  )
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.eks_igw.id
  depends_on             = [aws_internet_gateway.eks_igw]
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.private_nat.id
  depends_on             = [aws_nat_gateway.private_nat]
}

resource "aws_route_table_association" "public_rt_assoc" {
  count          = length(local.public_subnets)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_rt_assoc" {
  count          = length(local.private_subnets)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private_route_table.id
}
