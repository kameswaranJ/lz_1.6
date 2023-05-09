# TODO externalize retrieval of variable to external module

data "aws_ssm_parameters_by_path" "deploy_vars" {
  provider = aws.deploy
  path     = local.lz_deploy_var_path
}

data "aws_ssm_parameters_by_path" "deploy_core_vars" {
  provider = aws.deploy_core
  path     = local.lz_deploy_var_path
}

data "aws_ssm_parameters_by_path" "legacy_app_vars" {
  provider = aws.app
  path     = "/lz/tfvars"
}

data "aws_ssm_parameters_by_path" "app_vars" {
  provider = aws.app
  path     = local.lz_app_var_path
}

locals {
  # Deploy variables
  lz_deploy_var_path   = "/lz/tfvars/${var.stla_region}"
  # Are app variables stored in legacy location (without fully qualified name prefix) ?
  lz_app_var_is_legacy = contains(data.aws_ssm_parameters_by_path.legacy_app_vars.names, "/lz/tfvars/account_type")
  # Path is determined according to legacy mode or not
  lz_app_var_path      = local.lz_app_var_is_legacy ? "/lz/tfvars" : "/lz/tfvars/${local.fq_name}"
  lz_app_var_new_path  = "/lz/tfvars/${local.fq_name}"

  # Deploy variables for core region
  ssm_deploy_core_vars  = zipmap([for k in data.aws_ssm_parameters_by_path.deploy_core_vars.names : substr(k, length(local.lz_deploy_var_path) + 1, -1)], data.aws_ssm_parameters_by_path.deploy_core_vars.values)
  # Deploy variables for target region
  ssm_deploy_local_vars = zipmap([for k in data.aws_ssm_parameters_by_path.deploy_vars.names : substr(k, length(local.lz_deploy_var_path) + 1, -1)], data.aws_ssm_parameters_by_path.deploy_vars.values)
  # Final deploy vars = core region vars + target region vars
  ssm_deploy_vars       = merge(local.ssm_deploy_core_vars, local.ssm_deploy_local_vars)
  # App vars
  ssm_app_vars          = zipmap([for k in data.aws_ssm_parameters_by_path.app_vars.names : substr(k, length(local.lz_app_var_path) + 1, -1)], data.aws_ssm_parameters_by_path.app_vars.values)
}

resource "aws_ssm_parameter" "version" {
  #checkov:skip=CKV2_AWS_34:Parameter value is not sensitive
  provider = aws.app

  name  = "${local.lz_app_var_new_path}/version"
  type  = "String"
  value = local.version_raw
}

resource "aws_ssm_parameter" "network_model" {
  #checkov:skip=CKV2_AWS_34:Parameter value is not sensitive
  provider = aws.app

  name  = "${local.lz_app_var_new_path}/network_model"
  type  = "String"
  value = local.network_model
}

resource "aws_ssm_parameter" "hosted_zone" {
  #checkov:skip=CKV2_AWS_34:Parameter value is not sensitive
  provider = aws.app

  name  = "${local.lz_app_var_new_path}/hosted_zone"
  type  = "String"
  value = local.hosted_zone
}

resource "aws_ssm_parameter" "domain_name" {
  #checkov:skip=CKV2_AWS_34:Parameter value is not sensitive
  provider = aws.app

  name  = "${local.lz_app_var_new_path}/domain_name"
  type  = "String"
  value = local.domain_name
}

resource "aws_ssm_parameter" "flow_logs_format" {
  #checkov:skip=CKV2_AWS_34:Parameter value is not sensitive
  provider = aws.app

  name  = "${local.lz_app_var_new_path}/flow_logs_format"
  type  = "String"
  value = local.flow_logs_format
}

resource "aws_ssm_parameter" "vpc_sensitivity" {
  #checkov:skip=CKV2_AWS_34:Parameter value is not sensitive
  provider = aws.app

  name  = "${local.lz_app_var_new_path}/vpc_sensitivity"
  type  = "String"
  value = local.vpc_sensitivity
}

resource "aws_ssm_parameter" "vpc_count" {
  #checkov:skip=CKV2_AWS_34:Parameter value is not sensitive
  provider = aws.app

  name  = "${local.lz_app_var_new_path}/vpc_count"
  type  = "String"
  value = local.vpc_count
}

resource "aws_ssm_parameter" "frontend_netmask_length" {
  #checkov:skip=CKV2_AWS_34:Parameter value is not sensitive
  provider = aws.app

  name  = "${local.lz_app_var_new_path}/frontend_netmask_length"
  type  = "String"
  value = local.frontend_netmask_length
}

resource "aws_ssm_parameter" "frontend_subnet_count" {
  #checkov:skip=CKV2_AWS_34:Parameter value is not sensitive
  provider = aws.app

  name  = "${local.lz_app_var_new_path}/frontend_subnet_count"
  type  = "String"
  value = local.frontend_subnet_count
}

resource "aws_ssm_parameter" "backend_netmask_length" {
  #checkov:skip=CKV2_AWS_34:Parameter value is not sensitive
  provider = aws.app

  name  = "${local.lz_app_var_new_path}/backend_netmask_length"
  type  = "String"
  value = local.backend_netmask_length
}

resource "aws_ssm_parameter" "backend_subnet_count" {
  #checkov:skip=CKV2_AWS_34:Parameter value is not sensitive
  provider = aws.app

  name  = "${local.lz_app_var_new_path}/backend_subnet_count"
  type  = "String"
  value = local.backend_subnet_count
}

resource "aws_ssm_parameter" "routed_backend_netmask_length" {
  #checkov:skip=CKV2_AWS_34:Parameter value is not sensitive
  provider = aws.app

  name  = "${local.lz_app_var_new_path}/routed_backend_netmask_length"
  type  = "String"
  value = local.routed_backend_netmask_length
}

resource "aws_ssm_parameter" "routed_backend_subnet_count" {
  #checkov:skip=CKV2_AWS_34:Parameter value is not sensitive
  provider = aws.app

  name  = "${local.lz_app_var_new_path}/routed_backend_subnet_count"
  type  = "String"
  value = local.routed_backend_subnet_count
}

resource "aws_ssm_parameter" "dedicated_backend_cidr" {
  #checkov:skip=CKV2_AWS_34:Parameter value is not sensitive
  provider = aws.app

  name  = "${local.lz_app_var_new_path}/dedicated_backend_cidr"
  type  = "String"
  value = local.dedicated_backend_cidr
}

resource "aws_ssm_parameter" "subnet_share_pattern" {
  #checkov:skip=CKV2_AWS_34:Parameter value is not sensitive
  provider = aws.app

  name  = "${local.lz_app_var_new_path}/subnet_share_pattern"
  type  = "String"
  value = local.subnet_share_pattern
}

resource "aws_ssm_parameter" "subnet_share_alt" {
  #checkov:skip=CKV2_AWS_34:Parameter value is not sensitive
  provider = aws.app

  name  = "${local.lz_app_var_new_path}/subnet_share_alt"
  type  = "String"
  value = local.subnet_share_alt
}

resource "aws_ssm_parameter" "az_count" {
  #checkov:skip=CKV2_AWS_34:Parameter value is not sensitive
  provider = aws.app

  name  = "${local.lz_app_var_new_path}/az_count"
  type  = "String"
  value = local.az_count
}

resource "aws_ssm_parameter" "az_exclusion" {
  #checkov:skip=CKV2_AWS_34:Parameter value is not sensitive
  provider = aws.app

  name  = "${local.lz_app_var_new_path}/az_exclusion"
  type  = "String"
  value = local.az_exclusion_raw
}

resource "aws_ssm_parameter" "deploy_global_resources" {
  #checkov:skip=CKV2_AWS_34:Parameter value is not sensitive
  provider = aws.app

  name  = "${local.lz_app_var_new_path}/deploy_global_resources"
  type  = "String"
  value = local.deploy_global_resources
}

resource "aws_ssm_parameter" "flags" {
  #checkov:skip=CKV2_AWS_34:Parameter value is not sensitive
  provider = aws.app

  name  = "${local.lz_app_var_new_path}/flags"
  type  = "String"
  value = local.flags_raw
}

resource "aws_ssm_parameter" "uniqueness_suffix" {
  #checkov:skip=CKV2_AWS_34:Parameter value is not sensitive
  provider = aws.app

  name  = "${local.lz_app_var_new_path}/uniqueness_suffix"
  type  = "String"
  value = random_string.uniqueness_suffix.result
}
