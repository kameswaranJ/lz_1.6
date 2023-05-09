terraform {
  required_version = ">= 1.2.0"

  required_providers {
    aws = {
      version               = "~> 4.57.0"
      configuration_aliases = [
        aws.app,
        aws.hub,
        aws.hub_alt,
        aws.hub_core,
        aws.shared,
        aws.shared_core,
        aws.deploy,
        aws.deploy_core,
      ]
    }
    restapi = {
      source                = "mastercard/restapi"
      version               = "~> 1.18.0"
      configuration_aliases = [
        restapi.palo_alto
      ]
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.0"
    }
  }
}

data "aws_region" "current" {
  provider = aws.app
}

data "aws_region" "alt" {
  provider = aws.hub_alt
}

data "aws_caller_identity" "app" {
  provider = aws.app
}

data "aws_availability_zones" "all" {
  provider = aws.app
  state    = "available"

  filter {
    name   = "group-name"
    values = [data.aws_region.current.id]
  }
}

data "aws_iam_role" "vpc_flow_logs" {
  provider = aws.app
  count    = local.deploy_global_resources ? 0 : 1

  name = "role-${local.fq_name}-vpc-flow-logs"
}

locals {
  version_raw              = trimspace(file("${path.module}/VERSION"))
  version_to_deploy        = regex("^v(?P<x>\\d+)\\.?(?P<y>\\d+)\\.?(?P<z>\\d+)(?P<count>-[0-9]+)?(?P<hash>-[a-z0-9]+)?$", local.version_raw)
  version_already_deployed = regex("^v(?P<x>\\d+)\\.?(?P<y>\\d+)\\.?(?P<z>\\d+)(?P<count>-[0-9]+)?(?P<hash>-[a-z0-9]+)?$", nonsensitive(lookup(local.ssm_app_vars, "version", "v0.0.0")))
}

resource null_resource version_check {
  lifecycle {
    precondition {
      condition     = var.allow_downgrade || (tonumber(local.version_to_deploy["x"]) > tonumber(local.version_already_deployed["x"])) || (tonumber(local.version_to_deploy["x"]) == tonumber(local.version_already_deployed["x"]) && tonumber(local.version_to_deploy["y"]) > tonumber(local.version_already_deployed["y"])) || (tonumber(local.version_to_deploy["x"]) == tonumber(local.version_already_deployed["x"]) && tonumber(local.version_to_deploy["y"]) == tonumber(local.version_already_deployed["y"]) && tonumber(local.version_to_deploy["z"]) >= tonumber(local.version_already_deployed["z"]))
      error_message = "Version downgrade is blocked. You can force it with -var 'allow_downgrade=true'"
    }
  }
}

# Automation user
resource "random_string" "uniqueness_suffix" {
  length  = 8
  special = false
  upper   = false
  lower   = true
}


module "global" {
  source    = "./global"
  count     = local.deploy_global_resources ? 1 : 0
  providers = {
    aws.app : aws.app
    aws.deploy : aws.deploy
  }

  account_id        = data.aws_caller_identity.app.account_id
  fq_name           = local.fq_name
  secret_regions    = [for region in split(",", nonsensitive(local.ssm_deploy_vars["operating_regions"])) : region if region != data.aws_region.current.id]
  uniqueness_suffix = random_string.uniqueness_suffix.result
}
