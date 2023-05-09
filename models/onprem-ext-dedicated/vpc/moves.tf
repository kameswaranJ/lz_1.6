moved {
  from = module.frontend_allocation
  to = module.frontend_allocation[0]
}

moved {
  from = aws_subnet.frontend["0_eu-west-1a"]
  to = aws_subnet.frontend["0_0_eu-west-1a"]
}

moved {
  from = aws_subnet.frontend["0_eu-west-1b"]
  to = aws_subnet.frontend["0_0_eu-west-1b"]
}

moved {
  from = aws_subnet.frontend["0_eu-west-1c"]
  to = aws_subnet.frontend["0_0_eu-west-1c"]
}

moved {
  from = aws_subnet.frontend["0_eu-west-3a"]
  to = aws_subnet.frontend["0_0_eu-west-3a"]
}

moved {
  from = aws_subnet.frontend["0_eu-west-3b"]
  to = aws_subnet.frontend["0_0_eu-west-3b"]
}

moved {
  from = aws_subnet.frontend["0_eu-west-3c"]
  to = aws_subnet.frontend["0_0_eu-west-3c"]
}

moved {
  from = aws_subnet.frontend["0_us-east-1a"]
  to = aws_subnet.frontend["0_0_us-east-1a"]
}

moved {
  from = aws_subnet.frontend["0_us-east-1b"]
  to = aws_subnet.frontend["0_0_us-east-1b"]
}

moved {
  from = aws_subnet.frontend["0_us-east-1c"]
  to = aws_subnet.frontend["0_0_us-east-1c"]
}

moved {
  from = aws_subnet.frontend["0_us-east-1d"]
  to = aws_subnet.frontend["0_0_us-east-1d"]
}

moved {
  from = aws_subnet.frontend["0_us-east-1e"]
  to = aws_subnet.frontend["0_0_us-east-1e"]
}

moved {
  from = aws_subnet.frontend["0_us-east-1f"]
  to = aws_subnet.frontend["0_0_us-east-1f"]
}

moved {
  from = aws_route_table_association.frontend["0_eu-west-1a"]
  to = aws_route_table_association.frontend["0_0_eu-west-1a"]
}

moved {
  from = aws_route_table_association.frontend["0_eu-west-1b"]
  to = aws_route_table_association.frontend["0_0_eu-west-1b"]
}

moved {
  from = aws_route_table_association.frontend["0_eu-west-1c"]
  to = aws_route_table_association.frontend["0_0_eu-west-1c"]
}

moved {
  from = aws_route_table_association.frontend["0_eu-west-3a"]
  to = aws_route_table_association.frontend["0_0_eu-west-3a"]
}

moved {
  from = aws_route_table_association.frontend["0_eu-west-3b"]
  to = aws_route_table_association.frontend["0_0_eu-west-3b"]
}

moved {
  from = aws_route_table_association.frontend["0_eu-west-3c"]
  to = aws_route_table_association.frontend["0_0_eu-west-3c"]
}

moved {
  from = aws_route_table_association.frontend["0_us-east-1a"]
  to = aws_route_table_association.frontend["0_0_us-east-1a"]
}

moved {
  from = aws_route_table_association.frontend["0_us-east-1b"]
  to = aws_route_table_association.frontend["0_0_us-east-1b"]
}

moved {
  from = aws_route_table_association.frontend["0_us-east-1c"]
  to = aws_route_table_association.frontend["0_0_us-east-1c"]
}

moved {
  from = aws_route_table_association.frontend["0_us-east-1d"]
  to = aws_route_table_association.frontend["0_0_us-east-1d"]
}

moved {
  from = aws_route_table_association.frontend["0_us-east-1e"]
  to = aws_route_table_association.frontend["0_0_us-east-1e"]
}

moved {
  from = aws_route_table_association.frontend["0_us-east-1f"]
  to = aws_route_table_association.frontend["0_0_us-east-1f"]
}

moved {
  from = aws_vpc_ipam_pool_cidr_allocation.frontend
  to = module.frontend_allocation.aws_vpc_ipam_pool_cidr_allocation.full
}

moved {
  from = aws_vpc_ipam_pool_cidr_allocation.backend
  to = module.backend_allocation.aws_vpc_ipam_pool_cidr_allocation.full
}

moved {
  from = aws_subnet.frontend["eu-west-1a"]
  to = aws_subnet.frontend["0_eu-west-1a"]
}

moved {
  from = aws_subnet.frontend["eu-west-1b"]
  to = aws_subnet.frontend["0_eu-west-1b"]
}

moved {
  from = aws_route_table_association.frontend["eu-west-1a"]
  to = aws_route_table_association.frontend["0_eu-west-1a"]
}

moved {
  from = aws_route_table_association.frontend["eu-west-1b"]
  to = aws_route_table_association.frontend["0_eu-west-1b"]
}

