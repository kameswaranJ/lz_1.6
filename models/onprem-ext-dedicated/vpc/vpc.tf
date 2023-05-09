data "aws_vpc_ipam_pool" "frontend" {
  provider = aws.shared_core

  filter {
    name   = "tag:subnet_type"
    values = ["frontend"]
  }

  filter {
    name   = "tag:stla_region"
    values = [var.stla_region]
  }

  filter {
    name   = "locale"
    values = [data.aws_region.current.id]
  }
}

## FRONTEND

module frontend_allocation {
  source    = "../../../commons/subnet-allocation"
  count     = var.frontend_subnet_count
  providers = {
    aws.shared = aws.shared
  }

  name               = var.name
  ipam_pool_id       = data.aws_vpc_ipam_pool.frontend.id
  availability_zones = var.availability_zones
  subnet_count       = 1
  netmask_length     = var.frontend_netmask_length
  subnet_prefix      = count.index
}

resource "aws_vpc" "main" {
  provider = aws.app

  cidr_block           = module.frontend_allocation[0].cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "vpc-${var.name}"
  }
}

resource "aws_default_security_group" "default" {
  provider = aws.app

  vpc_id = aws_vpc.main.id
}

resource "aws_vpc_ipv4_cidr_block_association" "vpc_frontend_cidr" {
  provider = aws.app
  count    = var.frontend_subnet_count - 1

  vpc_id     = aws_vpc.main.id
  cidr_block = module.frontend_allocation[count.index + 1].cidr
}

resource "aws_ec2_tag" "main_route_table" {
  provider = aws.app

  resource_id = aws_vpc.main.main_route_table_id
  key         = "Name"
  value       = "rt-${var.name}-main"
}

resource "aws_subnet" "frontend" {
  provider   = aws.app
  for_each   = merge([for alloc in module.frontend_allocation : alloc.subnets]...)
  depends_on = [aws_vpc_ipv4_cidr_block_association.vpc_frontend_cidr]

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["az"]

  tags = {
    Name = "sn-${var.name}-frontend-${each.value["prefix"]}-${each.value["az"]}"
  }
}

## BACKEND

resource "aws_vpc_ipv4_cidr_block_association" "vpc_secondary_cidr" {
  provider = aws.app

  vpc_id     = aws_vpc.main.id
  cidr_block = var.backend_cidr # Full backend CIDR is attached
}

module backend_allocation {
  source    = "../../../commons/subnet-allocation"
  providers = {
    aws.shared = aws.shared
  }

  name               = var.name
  cidr               = var.backend_cidr
  availability_zones = var.availability_zones
  subnet_count       = var.backend_subnet_count
  netmask_length     = var.backend_netmask_length
}

resource "aws_subnet" "backend" {
  provider   = aws.app
  for_each   = module.backend_allocation.subnets
  depends_on = [aws_vpc_ipv4_cidr_block_association.vpc_secondary_cidr]

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["az"]

  tags = {
    Name = "sn-${var.name}-backend-${each.value["idx"]}-${each.value["az"]}"
  }
}

## ROUTED BACKEND

module routed_backend_allocation {
  source    = "../../../commons/subnet-allocation"
  count     = var.routed_backend_subnet_count
  providers = {
    aws.shared = aws.shared
  }

  name               = var.name
  ipam_pool_id       = data.aws_vpc_ipam_pool.frontend.id
  availability_zones = var.availability_zones
  subnet_count       = 1
  netmask_length     = var.routed_backend_netmask_length
  subnet_prefix      = count.index
}

resource "aws_vpc_ipv4_cidr_block_association" "vpc_routed_backend_cidr" {
  provider = aws.app
  count    = var.routed_backend_subnet_count

  vpc_id     = aws_vpc.main.id
  cidr_block = module.routed_backend_allocation[count.index].cidr
}

resource "aws_subnet" "routed_backend" {
  provider   = aws.app
  for_each   = merge([for alloc in module.routed_backend_allocation : alloc.subnets]...)
  depends_on = [aws_vpc_ipv4_cidr_block_association.vpc_routed_backend_cidr]

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["az"]

  tags = {
    Name = "sn-${var.name}-routed-backend-${each.value["prefix"]}-${each.value["az"]}"
  }
}
