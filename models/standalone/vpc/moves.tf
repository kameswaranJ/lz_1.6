# Updated names for endpoint associations
moved {
  from = aws_vpc_endpoint_subnet_association.aws
  to = aws_vpc_endpoint_subnet_association.aws_sn
}

moved {
  from = aws_vpc_endpoint_security_group_association.aws
  to = aws_vpc_endpoint_security_group_association.aws_sg
}

# Refactored the naming scheme of backend subnets starting from 1.4.0 (should only exist in eu-west-3)
moved {
  from = aws_subnet.private["eu-west-3a"]
  to   = aws_subnet.private["0_eu-west-3a"]
}

moved {
  from = aws_subnet.private["eu-west-3b"]
  to   = aws_subnet.private["0_eu-west-3b"]
}

moved {
  from = aws_subnet.private["eu-west-3c"]
  to   = aws_subnet.private["0_eu-west-3c"]
}

moved {
  from = aws_route_table_association.private["eu-west-3a"]
  to   = aws_route_table_association.private["0_eu-west-3a"]
}

moved {
  from = aws_route_table_association.private["eu-west-3b"]
  to   = aws_route_table_association.private["0_eu-west-3b"]
}

moved {
  from = aws_route_table_association.private["eu-west-3c"]
  to   = aws_route_table_association.private["0_eu-west-3c"]
}

# Refactored route tables keys starting from 1.6.1
moved {
  from = aws_route_table.private["eu-west-3a"]
  to = aws_route_table.private["0_eu-west-3a"]
}

moved {
  from = aws_route_table.private["eu-west-3b"]
  to = aws_route_table.private["0_eu-west-3b"]
}

moved {
  from = aws_route_table.private["eu-west-3c"]
  to = aws_route_table.private["0_eu-west-3c"]
}

moved {
  from = aws_route_table.private["eu-west-1a"]
  to = aws_route_table.private["0_eu-west-1a"]
}

moved {
  from = aws_route_table.private["eu-west-1b"]
  to = aws_route_table.private["0_eu-west-1b"]
}

moved {
  from = aws_route_table.private["eu-west-1c"]
  to = aws_route_table.private["0_eu-west-1c"]
}

## Old moves because naming was changed two times (removed when all accounts upgraded)
#moved {
#  from = aws_subnet.private["0-eu-west-3a"]
#  to   = aws_subnet.private["0_eu-west-3a"]
#}
#
#moved {
#  from = aws_subnet.private["0-eu-west-3b"]
#  to   = aws_subnet.private["0_eu-west-3b"]
#}
#
#moved {
#  from = aws_subnet.private["0-eu-west-3c"]
#  to   = aws_subnet.private["0_eu-west-3c"]
#}
#
#moved {
#  from = aws_route_table_association.private["0-eu-west-3a"]
#  to   = aws_route_table_association.private["0_eu-west-3a"]
#}
#
#moved {
#  from = aws_route_table_association.private["0-eu-west-3b"]
#  to   = aws_route_table_association.private["0_eu-west-3b"]
#}
#
#moved {
#  from = aws_route_table_association.private["0-eu-west-3c"]
#  to   = aws_route_table_association.private["0_eu-west-3c"]
#}
#
#moved {
#  from = aws_subnet.private["1-eu-west-3a"]
#  to   = aws_subnet.private["1_eu-west-3a"]
#}
#
#moved {
#  from = aws_subnet.private["1-eu-west-3b"]
#  to   = aws_subnet.private["1_eu-west-3b"]
#}
#
#moved {
#  from = aws_subnet.private["1-eu-west-3c"]
#  to   = aws_subnet.private["1_eu-west-3c"]
#}
#
#moved {
#  from = aws_route_table_association.private["1-eu-west-3a"]
#  to   = aws_route_table_association.private["1_eu-west-3a"]
#}
#
#moved {
#  from = aws_route_table_association.private["1-eu-west-3b"]
#  to   = aws_route_table_association.private["1_eu-west-3b"]
#}
#
#moved {
#  from = aws_route_table_association.private["1-eu-west-3c"]
#  to   = aws_route_table_association.private["1_eu-west-3c"]
#}
#
## Old moves because naming was changed two times (removed when all accounts upgraded)
#moved {
#  from = aws_subnet.private["0-eu-west-1a"]
#  to   = aws_subnet.private["0_eu-west-1a"]
#}
#
#moved {
#  from = aws_subnet.private["0-eu-west-1b"]
#  to   = aws_subnet.private["0_eu-west-1b"]
#}
#
#moved {
#  from = aws_subnet.private["0-eu-west-1c"]
#  to   = aws_subnet.private["0_eu-west-1c"]
#}
#
#moved {
#  from = aws_route_table_association.private["0-eu-west-1a"]
#  to   = aws_route_table_association.private["0_eu-west-1a"]
#}
#
#moved {
#  from = aws_route_table_association.private["0-eu-west-1b"]
#  to   = aws_route_table_association.private["0_eu-west-1b"]
#}
#
#moved {
#  from = aws_route_table_association.private["0-eu-west-1c"]
#  to   = aws_route_table_association.private["0_eu-west-1c"]
#}
#
#moved {
#  from = aws_subnet.private["1-eu-west-1a"]
#  to   = aws_subnet.private["1_eu-west-1a"]
#}
#
#moved {
#  from = aws_subnet.private["1-eu-west-1b"]
#  to   = aws_subnet.private["1_eu-west-1b"]
#}
#
#moved {
#  from = aws_subnet.private["1-eu-west-1c"]
#  to   = aws_subnet.private["1_eu-west-1c"]
#}
#
#moved {
#  from = aws_route_table_association.private["1-eu-west-1a"]
#  to   = aws_route_table_association.private["1_eu-west-1a"]
#}
#
#moved {
#  from = aws_route_table_association.private["1-eu-west-1b"]
#  to   = aws_route_table_association.private["1_eu-west-1b"]
#}
#
#moved {
#  from = aws_route_table_association.private["1-eu-west-1c"]
#  to   = aws_route_table_association.private["1_eu-west-1c"]
#}
