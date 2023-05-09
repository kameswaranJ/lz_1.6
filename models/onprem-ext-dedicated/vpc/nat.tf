resource "aws_nat_gateway" "nat" {
  provider = aws.app
  for_each = {for k, v in aws_subnet.backend : k => v if can(regex("^0_", k))}  # Only one subnet per-AZ

  connectivity_type = "private"
  subnet_id         = [for frontend_subnet in aws_subnet.frontend : frontend_subnet.id if frontend_subnet.availability_zone == each.value["availability_zone"]][0]

  tags = {
    Name = "nat-${each.value["tags"]["Name"]}"
  }
}
