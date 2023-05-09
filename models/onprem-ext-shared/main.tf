terraform {
  required_providers {
    aws = {
      configuration_aliases = [aws.app, aws.hub, aws.hub_alt, aws.hub_core, aws.shared, aws.shared_core]
    }
  }
}

data "aws_region" "current" {
  provider = aws.app
}

data "aws_caller_identity" "app" {
  provider = aws.app
}

data "aws_region" "alt" {
  provider = aws.hub_alt
}

module "shared_vpc" {
  source    = "./vpc"
  providers = {
    aws.app : aws.app
    aws.hub : aws.hub
    aws.shared : aws.shared
    aws.shared_core : aws.shared_core
  }

  name                     = "${var.fqName}-0"
  frontend_share_arn       = data.aws_ram_resource_share.effective_share.arn
  backend_netmask_length   = var.backend_netmask_length
  backend_subnet_count     = var.backend_subnet_count
  legacy_subnet_allocation = var.legacy_subnet_allocation
  app_default_tags         = var.app_default_tags
  shared_role              = var.shared_role
}
