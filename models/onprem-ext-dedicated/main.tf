terraform {
  required_providers {
    aws = {
      configuration_aliases = [aws.app, aws.hub, aws.hub_alt, aws.hub_core, aws.shared, aws.shared_core]
    }
  }
}

data "aws_caller_identity" "app" {
  provider = aws.app
}

data "aws_region" "alt" {
  provider = aws.hub_alt
}

module "dedicated_vpc" {
  source    = "./vpc"
  count     = var.vpc_count
  providers = {
    aws.app : aws.app
    aws.hub : aws.hub
    aws.shared : aws.shared
    aws.shared_core : aws.shared_core
  }

  stla_region                   = var.stla_region
  availability_zones            = var.availability_zones
  fqName                        = var.fqName
  name                          = "${var.fqName}-${count.index}"
  frontend_netmask_length       = var.frontend_netmask_length
  frontend_subnet_count         = var.frontend_subnet_count
  backend_netmask_length        = var.backend_netmask_length
  backend_subnet_count          = var.backend_subnet_count
  routed_backend_netmask_length = var.routed_backend_netmask_length
  routed_backend_subnet_count   = var.routed_backend_subnet_count
  backend_cidr                  = var.backend_cidr
  tgw_id                        = var.tgw_id
  tgw_share_name                = var.tgw_share_name
  dns_share_name                = var.dns_forward_share
  flow_logs_format              = var.flow_logs_format
  flow_logs_role_arn            = var.flow_logs_role_arn
}
