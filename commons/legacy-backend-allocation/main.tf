terraform {
  required_providers {
    aws = {
      configuration_aliases = [aws.shared]
    }
  }
}
resource "aws_vpc_ipam_preview_next_cidr" "backend_1" {
  provider = aws.shared

  ipam_pool_id   = var.ipam_pool_id
  netmask_length = var.netmask_length
}

resource "aws_vpc_ipam_preview_next_cidr" "backend_2" {
  provider = aws.shared

  ipam_pool_id   = var.ipam_pool_id
  netmask_length = var.netmask_length

  disallowed_cidrs = [
    aws_vpc_ipam_preview_next_cidr.backend_1.cidr
  ]
}

resource "aws_vpc_ipam_preview_next_cidr" "backend_3" {
  provider = aws.shared

  ipam_pool_id   = var.ipam_pool_id
  netmask_length = var.netmask_length

  disallowed_cidrs = [
    aws_vpc_ipam_preview_next_cidr.backend_1.cidr,
    aws_vpc_ipam_preview_next_cidr.backend_2.cidr
  ]
}

resource "aws_vpc_ipam_preview_next_cidr" "backend_4" {
  provider = aws.shared

  ipam_pool_id   = var.ipam_pool_id
  netmask_length = var.netmask_length

  disallowed_cidrs = [
    aws_vpc_ipam_preview_next_cidr.backend_1.cidr,
    aws_vpc_ipam_preview_next_cidr.backend_2.cidr,
    aws_vpc_ipam_preview_next_cidr.backend_3.cidr
  ]
}

resource "aws_vpc_ipam_preview_next_cidr" "backend_5" {
  provider = aws.shared

  ipam_pool_id   = var.ipam_pool_id
  netmask_length = var.netmask_length

  disallowed_cidrs = [
    aws_vpc_ipam_preview_next_cidr.backend_1.cidr,
    aws_vpc_ipam_preview_next_cidr.backend_2.cidr,
    aws_vpc_ipam_preview_next_cidr.backend_3.cidr,
    aws_vpc_ipam_preview_next_cidr.backend_4.cidr
  ]
}

resource "aws_vpc_ipam_preview_next_cidr" "backend_6" {
  provider = aws.shared

  ipam_pool_id   = var.ipam_pool_id
  netmask_length = var.netmask_length

  disallowed_cidrs = [
    aws_vpc_ipam_preview_next_cidr.backend_1.cidr,
    aws_vpc_ipam_preview_next_cidr.backend_2.cidr,
    aws_vpc_ipam_preview_next_cidr.backend_3.cidr,
    aws_vpc_ipam_preview_next_cidr.backend_4.cidr,
    aws_vpc_ipam_preview_next_cidr.backend_5.cidr
  ]
}

resource "aws_vpc_ipam_preview_next_cidr" "backend_7" {
  provider = aws.shared

  ipam_pool_id   = var.ipam_pool_id
  netmask_length = var.netmask_length

  disallowed_cidrs = [
    aws_vpc_ipam_preview_next_cidr.backend_1.cidr,
    aws_vpc_ipam_preview_next_cidr.backend_2.cidr,
    aws_vpc_ipam_preview_next_cidr.backend_3.cidr,
    aws_vpc_ipam_preview_next_cidr.backend_4.cidr,
    aws_vpc_ipam_preview_next_cidr.backend_5.cidr,
    aws_vpc_ipam_preview_next_cidr.backend_6.cidr
  ]
}

resource "aws_vpc_ipam_preview_next_cidr" "backend_8" {
  provider = aws.shared

  ipam_pool_id   = var.ipam_pool_id
  netmask_length = var.netmask_length

  disallowed_cidrs = [
    aws_vpc_ipam_preview_next_cidr.backend_1.cidr,
    aws_vpc_ipam_preview_next_cidr.backend_2.cidr,
    aws_vpc_ipam_preview_next_cidr.backend_3.cidr,
    aws_vpc_ipam_preview_next_cidr.backend_4.cidr,
    aws_vpc_ipam_preview_next_cidr.backend_5.cidr,
    aws_vpc_ipam_preview_next_cidr.backend_6.cidr,
    aws_vpc_ipam_preview_next_cidr.backend_7.cidr
  ]
}

locals {
  backend_cidrs = [
    aws_vpc_ipam_preview_next_cidr.backend_1.cidr,
    aws_vpc_ipam_preview_next_cidr.backend_2.cidr,
    aws_vpc_ipam_preview_next_cidr.backend_3.cidr,
    aws_vpc_ipam_preview_next_cidr.backend_4.cidr,
    aws_vpc_ipam_preview_next_cidr.backend_5.cidr,
    aws_vpc_ipam_preview_next_cidr.backend_6.cidr,
    aws_vpc_ipam_preview_next_cidr.backend_7.cidr,
    aws_vpc_ipam_preview_next_cidr.backend_8.cidr,
  ]
  backend_subnets = {
  for i in setproduct(var.availability_zones, range(0, var.subnet_count, 1)) : format("%s_%s", i[1], i[0]) => {
    az : i[0]
    idx : i[1]
    cidr : local.backend_cidrs[i[1]*var.subnet_count + index(var.availability_zones, i[0])]
  }
  }
}

resource "aws_vpc_ipam_pool_cidr_allocation" "backend" {
  provider = aws.shared
  for_each = local.backend_subnets

  ipam_pool_id = var.ipam_pool_id
  cidr         = each.value["cidr"]
  description  = "IP allocation for sn-${var.name}-backend-${each.value["az"]}"
}