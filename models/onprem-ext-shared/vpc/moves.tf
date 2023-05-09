# Refactored the naming scheme of backend subnets starting from 1.4.0 (should only exist in eu-west-3)
moved {
  from = aws_subnet.backend["eu-west-3a"]
  to   = aws_subnet.backend["0_eu-west-3a"]
}

moved {
  from = aws_subnet.backend["eu-west-3b"]
  to   = aws_subnet.backend["0_eu-west-3b"]
}

moved {
  from = aws_subnet.backend["eu-west-3c"]
  to   = aws_subnet.backend["0_eu-west-3c"]
}

moved {
  from = aws_vpc_ipam_pool_cidr_allocation.example["eu-west-3a"]
  to = aws_vpc_ipam_pool_cidr_allocation.backend["0_eu-west-3a"]
}

moved {
  from = aws_vpc_ipam_pool_cidr_allocation.example["eu-west-3b"]
  to = aws_vpc_ipam_pool_cidr_allocation.backend["0_eu-west-3b"]
}

moved {
  from = aws_vpc_ipam_pool_cidr_allocation.example["eu-west-3c"]
  to = aws_vpc_ipam_pool_cidr_allocation.backend["0_eu-west-3c"]
}

moved {
  from = aws_route_table.backend["eu-west-3a"]
  to = aws_route_table.backend["0_eu-west-3a"]
}

moved {
  from = aws_route_table.backend["eu-west-3b"]
  to = aws_route_table.backend["0_eu-west-3b"]
}

moved {
  from = aws_route_table.backend["eu-west-3c"]
  to = aws_route_table.backend["0_eu-west-3c"]
}

moved {
  from = aws_route_table_association.backend["eu-west-3a"]
  to   = aws_route_table_association.backend["0_eu-west-3a"]
}

moved {
  from = aws_route_table_association.backend["eu-west-3b"]
  to   = aws_route_table_association.backend["0_eu-west-3b"]
}

moved {
  from = aws_route_table_association.backend["eu-west-3c"]
  to   = aws_route_table_association.backend["0_eu-west-3c"]
}

moved {
  from = aws_nat_gateway.nat["eu-west-3a"]
  to   = aws_nat_gateway.nat["0_eu-west-3a"]
}

moved {
  from = aws_nat_gateway.nat["eu-west-3b"]
  to   = aws_nat_gateway.nat["0_eu-west-3b"]
}

moved {
  from = aws_nat_gateway.nat["eu-west-3c"]
  to   = aws_nat_gateway.nat["0_eu-west-3c"]
}

moved {
  from = aws_ram_resource_association.backend_subnet["eu-west-3a"]
  to   = aws_ram_resource_association.backend_subnet["0_eu-west-3a"]
}

moved {
  from = aws_ram_resource_association.backend_subnet["eu-west-3b"]
  to   = aws_ram_resource_association.backend_subnet["0_eu-west-3b"]
}

moved {
  from = aws_ram_resource_association.backend_subnet["eu-west-3c"]
  to   = aws_ram_resource_association.backend_subnet["0_eu-west-3c"]
}

# Moves for backend IP allocation
moved {
  from = aws_vpc_ipam_preview_next_cidr.backend_1
  to   = module.legacy_backend_allocation[0].aws_vpc_ipam_preview_next_cidr.backend_1
}

moved {
  from = aws_vpc_ipam_preview_next_cidr.backend_2
  to   = module.legacy_backend_allocation[0].aws_vpc_ipam_preview_next_cidr.backend_2
}

moved {
  from = aws_vpc_ipam_preview_next_cidr.backend_3
  to   = module.legacy_backend_allocation[0].aws_vpc_ipam_preview_next_cidr.backend_3
}

moved {
  from = aws_vpc_ipam_preview_next_cidr.backend_4
  to   = module.legacy_backend_allocation[0].aws_vpc_ipam_preview_next_cidr.backend_4
}

moved {
  from = aws_vpc_ipam_preview_next_cidr.backend_5
  to   = module.legacy_backend_allocation[0].aws_vpc_ipam_preview_next_cidr.backend_5
}

moved {
  from = aws_vpc_ipam_preview_next_cidr.backend_6
  to   = module.legacy_backend_allocation[0].aws_vpc_ipam_preview_next_cidr.backend_6
}

moved {
  from = aws_vpc_ipam_preview_next_cidr.backend_7
  to   = module.legacy_backend_allocation[0].aws_vpc_ipam_preview_next_cidr.backend_7
}

moved {
  from = aws_vpc_ipam_preview_next_cidr.backend_8
  to   = module.legacy_backend_allocation[0].aws_vpc_ipam_preview_next_cidr.backend_8
}

moved {
  from = aws_vpc_ipam_pool_cidr_allocation.backend
  to   = module.legacy_backend_allocation[0].aws_vpc_ipam_pool_cidr_allocation.backend
}
