resource "aws_route_table" "backend" {
  provider = aws.shared
  for_each = {for k, v in aws_subnet.backend : k => v if can(regex("^0_", k))}

  vpc_id = each.value["vpc_id"]

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[each.key].id
  }

  tags = {
    Name = "rt-${each.value["tags"]["Name"]}"
  }
}

resource "aws_route_table_association" "backend" {
  provider = aws.shared
  for_each = aws_subnet.backend

  subnet_id      = each.value.id
  route_table_id = aws_route_table.backend["0_${each.value.availability_zone}"].id
}
