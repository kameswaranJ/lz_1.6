data "aws_vpc_ipam_pool" "backend_pool" {
  provider = aws.shared_core

  filter {
    name   = "tag:associated_vpc_id"
    values = [data.aws_vpc.main.id]
  }

  filter {
    name   = "tag:subnet_type"
    values = ["backend"]
  }

  filter {
    name   = "tag:vpc_type"
    values = ["shared"]
  }

  filter {
    name   = "locale"
    values = [data.aws_region.current.id]
  }
}

module backend_allocation {
  source     = "../../../commons/subnet-allocation"
  count      = var.legacy_subnet_allocation ? 0 : 1
  depends_on = [aws_ram_principal_association.frontend] # Cannot proceed if RAM association is not complete
  providers  = {
    aws.shared = aws.shared
  }

  name               = var.name
  ipam_pool_id       = data.aws_vpc_ipam_pool.backend_pool.id
  availability_zones = local.effective_azs
  subnet_count       = var.backend_subnet_count
  netmask_length     = var.backend_netmask_length
}

module legacy_backend_allocation {
  source     = "../../../commons/legacy-backend-allocation"
  count      = var.legacy_subnet_allocation ? 1 : 0
  depends_on = [aws_ram_principal_association.frontend] # Cannot proceed if RAM association is not complete
  providers  = {
    aws.shared = aws.shared
  }

  name               = var.name
  ipam_pool_id       = data.aws_vpc_ipam_pool.backend_pool.id
  availability_zones = local.effective_azs
  subnet_count       = var.backend_subnet_count
  netmask_length     = var.backend_netmask_length
}

resource "aws_subnet" "backend" {
  provider = aws.shared
  for_each = var.legacy_subnet_allocation ? module.legacy_backend_allocation[0].subnets : module.backend_allocation[0].subnets

  vpc_id            = data.aws_vpc.main.id
  availability_zone = each.value["az"]
  cidr_block        = each.value["cidr"]

  tags = {
    Name = "sn-${var.name}-backend-${each.value["idx"]}-${each.value["az"]}"
  }
}

resource "aws_ram_resource_share" "backend_subnet" {
  provider = aws.shared

  name                      = "rs-subnet-${var.name}-backend"
  allow_external_principals = false

  permission_arns = ["arn:aws:ram::aws:permission/AWSRAMDefaultPermissionSubnet"]
}

resource "aws_ram_principal_association" "backend_subnet_app_account" {
  provider = aws.shared

  principal          = data.aws_caller_identity.app.account_id
  resource_share_arn = aws_ram_resource_share.backend_subnet.arn
}

resource "aws_ram_resource_association" "backend_subnet" {
  provider = aws.shared
  for_each = aws_subnet.backend

  resource_arn       = each.value.arn
  resource_share_arn = aws_ram_resource_share.backend_subnet.arn
}
