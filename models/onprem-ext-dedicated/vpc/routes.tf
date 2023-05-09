resource "aws_route_table" "frontend" {
  provider   = aws.app
  depends_on = [aws_ec2_transit_gateway_vpc_attachment.tgw]
  vpc_id     = aws_vpc.main.id

  route {
    cidr_block         = "0.0.0.0/0"
    transit_gateway_id = var.tgw_id
  }

  tags = {
    Name = "rt-${var.name}-frontend"
  }
}

resource "aws_route_table_association" "frontend" {
  provider = aws.app
  for_each = aws_subnet.frontend

  subnet_id      = each.value.id
  route_table_id = aws_route_table.frontend.id
}

resource "aws_route_table_association" "routed_backend" {
  provider = aws.app
  for_each = aws_subnet.routed_backend

  subnet_id      = each.value.id
  route_table_id = aws_route_table.frontend.id
}

resource "aws_route_table" "backend" {
  provider = aws.app
  for_each = {for k, v in aws_subnet.backend : k => v if can(regex("^0_", k))}  # Only one per-AZ

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
  provider = aws.app
  for_each = aws_subnet.backend

  subnet_id      = each.value.id
  route_table_id = aws_route_table.backend["0_${each.value.availability_zone}"].id
}
