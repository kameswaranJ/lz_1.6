resource "aws_nat_gateway" "nat" {
  provider = aws.shared
  for_each = {for k, v in aws_subnet.backend : k => v if can(regex("^0_", k))}

  connectivity_type = "private"
  subnet_id         = [for frontend_subnet in data.aws_subnet.frontend_subnets : frontend_subnet.id if frontend_subnet.availability_zone == each.value["availability_zone"]][0]

  tags = {
    Name = "nat-${each.value["tags"]["Name"]}"
  }
}
