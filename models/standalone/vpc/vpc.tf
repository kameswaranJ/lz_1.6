locals {
  # LEGACY variable subnet allocation: total subnet count is (1 frontend + n backends + 1 fw) * AZ count
  total_subnet_count = (1 + var.backend_subnet_count + 1) * length(var.availability_zones)
  # 1 is added to subnet_bit_shift to provision for /24 firewall subnet at the end of VPC range
  subnet_bit_shift   = var.legacy_subnet_allocation ? 8 - var.vpc_bit_shift : ceil(log(local.total_subnet_count, 2))

  fw_bits     = [for i in range(0, length(var.availability_zones), 1) : (12 - var.vpc_bit_shift)]
  pub_bits    = [for i in range(0, length(var.availability_zones), 1) : (var.frontend_netmask_length - 16 - var.vpc_bit_shift)]
  priv_bits   = [for i in range(0, length(var.availability_zones) * var.backend_subnet_count, 1) : (var.backend_netmask_length - 16 - var.vpc_bit_shift)]
  all_bits    = concat(local.fw_bits, local.pub_bits, local.priv_bits)
  all_subnets = cidrsubnets(var.cidr, local.all_bits...)
}

resource "aws_vpc" "standalone" {
  provider = aws.app

  cidr_block           = var.cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "vpc-${var.name}"
  }
}

resource "aws_default_security_group" "default" {
  provider = aws.app

  vpc_id = aws_vpc.standalone.id
}

resource "aws_subnet" "firewall" {
  provider = aws.app
  for_each = toset(var.availability_zones)

  vpc_id            = aws_vpc.standalone.id
  cidr_block        = var.legacy_subnet_allocation ? cidrsubnet(var.cidr, 8 - var.vpc_bit_shift, pow(2, 8 - var.vpc_bit_shift) - 1 - index(var.availability_zones, each.value)) : local.all_subnets[index(var.availability_zones, each.value)]
  availability_zone = each.value

  tags = {
    Name        = "sn-${var.name}-firewall-${each.value}"
    subnet_type = "lz-reserved"
  }
}

resource "aws_subnet" "public" {
  provider = aws.app
  for_each = toset(var.availability_zones)

  vpc_id            = aws_vpc.standalone.id
  cidr_block        = var.legacy_subnet_allocation ? cidrsubnet(var.cidr, 8 - var.vpc_bit_shift, index(var.availability_zones, each.value)) : local.all_subnets[(1*length(var.availability_zones)) + index(var.availability_zones, each.value)]
  availability_zone = each.value

  tags = {
    Name        = "sn-${var.name}-public-${each.value}"
    subnet_type = "frontend"
  }
}

locals {
  backend_subnets = {
  for i in setproduct(var.availability_zones, range(0, var.backend_subnet_count, 1)) : format("%s_%s", i[1], i[0]) => {
    az : i[0]
    idx : i[1]
    cidr : var.legacy_subnet_allocation ? cidrsubnet(var.cidr, 8 - var.vpc_bit_shift, 10 + (i[1] * length(var.availability_zones)) + index(var.availability_zones, i[0])) : local.all_subnets[(2*length(var.availability_zones)) + ((i[1] * length(var.availability_zones)) + index(var.availability_zones, i[0]))]
  }
  }
}

resource "aws_subnet" "private" {
  provider = aws.app
  for_each = local.backend_subnets

  vpc_id            = aws_vpc.standalone.id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["az"]

  tags = {
    Name         = "sn-${var.name}-private-${each.value["idx"]}-${each.value["az"]}"
    subnet_type  = "backend"
    subnet_index = each.value["idx"]
  }
}

resource "aws_vpc_endpoint" "fw_endpoint" {
  provider = aws.app
  for_each = toset(var.availability_zones)
  lifecycle {
    replace_triggered_by = [
      aws_subnet.firewall[each.key].id
    ]
  }

  service_name      = var.fw_eps_name
  subnet_ids        = [aws_subnet.firewall[each.value].id]
  vpc_endpoint_type = "GatewayLoadBalancer"
  vpc_id            = aws_vpc.standalone.id

  tags = {
    Name = "ep-${var.name}-fw-${aws_subnet.firewall[each.value].availability_zone}"
  }
}

resource "aws_internet_gateway" "igw" {
  provider = aws.app
  vpc_id   = aws_vpc.standalone.id

  tags = {
    Name = "igw-${var.name}"
  }
}
