resource "aws_ec2_tag" "main_vpc_defaults" {
  provider = aws.app
  for_each = var.tags

  resource_id = aws_vpc.standalone.main_route_table_id
  key         = each.key
  value       = each.value
}

resource "aws_ec2_tag" "main_vpc" {
  provider    = aws.app
  resource_id = aws_vpc.standalone.main_route_table_id
  key         = "Name"
  value       = "rt-${var.name}-main"
}
