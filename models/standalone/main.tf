terraform {
  required_providers {
    aws = {
      configuration_aliases = [aws.app, aws.hub]
    }
  }
}

data "aws_caller_identity" "app" {
  provider = aws.app
}

data "aws_availability_zones" "hub" {
  provider = aws.hub
}

data "aws_availability_zones" "app" {
  provider = aws.app
}

locals {
  vpc_bit_shift = var.legacy_subnet_allocation ? 3 : 0

  fw_az_ids                    = [for fw_az in data.aws_vpc_endpoint_service.firewall.availability_zones : data.aws_availability_zones.hub.zone_ids[index(data.aws_availability_zones.hub.names, fw_az)]]
  common_az_ids                = setintersection(local.fw_az_ids, var.available_az_ids)
  effective_availability_zones = slice(sort([for az_id in local.common_az_ids : data.aws_availability_zones.app.names[index(data.aws_availability_zones.app.zone_ids, az_id)]]), 0, var.az_count)
}

# VPCs
module "vpc" {
  source     = "./vpc"
  count      = var.vpc_count
  # Cannot proceed if principal association is not complete
  depends_on = [aws_vpc_endpoint_service_allowed_principal.firewall]
  providers  = {
    aws.app : aws.app
    aws.hub : aws.hub
  }

  fq_name                  = var.fqName
  name                     = "${var.fqName}-${count.index}"
  cidr                     = var.legacy_subnet_allocation ? cidrsubnet("192.168.0.0/16", local.vpc_bit_shift, count.index) : "192.168.0.0/16"
  vpc_bit_shift            = local.vpc_bit_shift
  availability_zones       = local.effective_availability_zones
  fw_eps_name              = var.fw_eps_name
  endpoint_services        = var.endpoint_services
  frontend_netmask_length  = var.frontend_netmask_length
  backend_subnet_count     = var.backend_subnet_count
  backend_netmask_length   = var.backend_netmask_length
  tags                     = var.tags
  flow_logs_format         = var.flow_logs_format
  flow_logs_role_arn       = var.flow_logs_role_arn
  legacy_subnet_allocation = var.legacy_subnet_allocation
}
