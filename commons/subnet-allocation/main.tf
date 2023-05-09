locals {
  total_subnet_count = length(var.availability_zones) * var.subnet_count
  # Amount of netmask bits necessary to fit all subnets: ceil(log2(total_subnet_count))
  bit_shift          = ceil(log(local.total_subnet_count, 2))
}

terraform {
  required_providers {
    aws = {
      configuration_aliases = [aws.shared]
    }
  }
}

resource "aws_vpc_ipam_pool_cidr_allocation" "full" {
  provider = aws.shared
  count    = var.ipam_pool_id != null ? 1 : 0

  ipam_pool_id   = var.ipam_pool_id
  netmask_length = var.netmask_length - local.bit_shift
  description    = "IP allocation for vpc-${var.name}"
}

locals {
  total_bit_shift = var.ipam_pool_id != null ? 0 : var.netmask_length - local.bit_shift - tonumber(split("/", var.cidr)[1])
  effective_cidr  = var.ipam_pool_id != null ? aws_vpc_ipam_pool_cidr_allocation.full[0].cidr : var.subnet_count == 0 ? var.cidr : cidrsubnet(var.cidr, local.total_bit_shift, 0)
  subnets         = {
  for i in setproduct(var.availability_zones, range(0, var.subnet_count, 1)) : format("%s%s_%s", var.subnet_prefix == "" ? "" : "${var.subnet_prefix}_", i[1], i[0]) => {
    az : i[0]
    idx : i[1]
    prefix : var.subnet_prefix
    cidr : cidrsubnet(local.effective_cidr, local.bit_shift, i[1]*length(var.availability_zones) + index(var.availability_zones, i[0]))
  }
  }
}

resource "null_resource" "check_bit_shift" {
  lifecycle {
    precondition {
      condition     = var.ipam_pool_id != null || local.total_bit_shift >= 0
      error_message = "Too many subnets for the available range ${coalesce(var.cidr, "<unknown>")}"
    }
  }
}

moved {
  from = aws_vpc_ipam_pool_cidr_allocation.full
  to   = aws_vpc_ipam_pool_cidr_allocation.full[0]
}
