locals {
  previous_network_model = lookup(local.ssm_app_vars, "network_model", lookup(local.ssm_app_vars, "account_type", "none"))
  network_model          = nonsensitive(coalesce(var.network_model == "<default>" ? null : var.network_model, local.previous_network_model))
  network_model_changed  = local.network_model != local.previous_network_model

  base_config     = yamldecode(file("${path.module}/config/base.yaml"))
  regional_config = try(yamldecode(file("${path.module}/config/stla_region/${var.stla_region}.yaml")), {})
  model_config    = try(yamldecode(file("${path.module}/config/network_model/${local.network_model}.yaml")), {})
  defaults        = merge(lookup(local.base_config, "defaults", {}), lookup(local.regional_config, "defaults", {}), lookup(local.model_config, "defaults", {}))

  # Basic info derived from the workspace name
  app_info = {
    app_name = var.app_id
    env_name = var.env_type
  }
  is_prod = local.app_info["env_name"] == "prod"
  prefix  = local.is_prod ? "" : "np-"
  fq_name = "${local.prefix}${local.app_info["app_name"]}-${local.app_info["env_name"]}"

  # Info coalesced from: explicit variable -> SSM var -> default value
  domain_name             = nonsensitive(coalesce(var.domain_name == "<default>" ? null : var.domain_name, lookup(local.ssm_app_vars, "domain_name", local.is_prod ? "${local.app_info["app_name"]}-${random_string.uniqueness_suffix.result}" : "${local.app_info["app_name"]}-${local.app_info["env_name"]}-${random_string.uniqueness_suffix.result}")))
  flow_logs_format        = nonsensitive(coalesce(var.flow_logs_format == "<default>" ? null : var.flow_logs_format, lookup(local.ssm_app_vars, "flow_logs_format", lookup(local.defaults, "flow_logs_format", ""))))
  deploy_global_resources = nonsensitive(coalesce(var.deploy_global_resources == "<default>" ? null : var.deploy_global_resources, tobool(lookup(local.ssm_app_vars, "deploy_global_resources", "true"))))
  vpc_sensitivity         = nonsensitive(coalesce(var.vpc_sensitivity == "<default>" ? null : var.vpc_sensitivity, lookup(local.ssm_app_vars, "vpc_sensitivity", lookup(local.defaults, "vpc_sensitivity", "standard"))))
  az_count                = tonumber(nonsensitive(coalesce(var.az_count == "<default>" ? null : var.az_count, lookup(local.ssm_app_vars, "az_count", lookup(local.defaults, "az_count", 2)))))
  az_exclusion_raw        = nonsensitive(coalesce(var.az_exclusion == "<default>" ? null : var.az_exclusion, lookup(local.ssm_app_vars, "az_exclusion", join(",", lookup(local.defaults, "az_exclusion", "<none>")))))
  az_exclusion            = split(",", local.az_exclusion_raw == "<none>" ? "" : local.az_exclusion_raw)

  # Info coalesced from: explicit variable -> SSM var (except if the network model has changed) -> default value
  hosted_zone                   = nonsensitive(coalesce(var.hosted_zone == "<default>" ? null : var.hosted_zone, lookup(local.ssm_app_vars, local.network_model_changed ? "__dummy__" : "hosted_zone", local.network_model == "standalone" ? local.ssm_deploy_vars["default_public_hosted_zone"] : local.ssm_deploy_vars["default_private_hosted_zone"])))
  vpc_count                     = tonumber(nonsensitive(coalesce(var.vpc_count == "<default>" ? null : var.vpc_count, lookup(local.ssm_app_vars, local.network_model_changed ? "__dummy__" : "vpc_count", lookup(local.defaults, "vpc_count", 0)))))
  frontend_netmask_length       = tonumber(nonsensitive(coalesce(var.frontend_netmask_length == "<default>" ? null : var.frontend_netmask_length, lookup(local.ssm_app_vars, local.network_model_changed ? "__dummy__" : "frontend_netmask_length", lookup(local.defaults, "frontend_netmask_length", 28)))))
  frontend_subnet_count         = tonumber(nonsensitive(coalesce(var.frontend_subnet_count == "<default>" ? null : var.frontend_subnet_count, lookup(local.ssm_app_vars, local.network_model_changed ? "__dummy__" : "frontend_subnet_count", lookup(local.defaults, "frontend_subnet_count", 0)))))
  backend_netmask_length        = tonumber(nonsensitive(coalesce(var.backend_netmask_length == "<default>" ? null : var.backend_netmask_length, lookup(local.ssm_app_vars, local.network_model_changed ? "__dummy__" : "backend_netmask_length", lookup(local.defaults, "backend_netmask_length", 28)))))
  backend_subnet_count          = tonumber(nonsensitive(coalesce(var.backend_subnet_count == "<default>" ? null : var.backend_subnet_count, lookup(local.ssm_app_vars, local.network_model_changed ? "__dummy__" : "backend_subnet_count", lookup(local.defaults, "backend_subnet_count", 0)))))
  routed_backend_netmask_length = tonumber(nonsensitive(coalesce(var.routed_backend_netmask_length == "<default>" ? null : var.routed_backend_netmask_length, lookup(local.ssm_app_vars, local.network_model_changed ? "__dummy__" : "routed_backend_netmask_length", lookup(local.defaults, "routed_backend_netmask_length", 0)))))
  routed_backend_subnet_count   = tonumber(nonsensitive(coalesce(var.routed_backend_subnet_count == "<default>" ? null : var.routed_backend_subnet_count, lookup(local.ssm_app_vars, local.network_model_changed ? "__dummy__" : "routed_backend_subnet_count", lookup(local.defaults, "routed_backend_subnet_count", 0)))))
  dedicated_backend_cidr        = nonsensitive(coalesce(var.dedicated_backend_cidr == "<default>" ? null : var.dedicated_backend_cidr, lookup(local.ssm_app_vars, local.network_model_changed ? "__dummy__" : "dedicated_backend_cidr", lookup(local.defaults, "dedicated_backend_cidr", "192.168.0.0/16"))))
  subnet_share_pattern          = nonsensitive(coalesce(var.subnet_share_pattern == "<default>" ? null : var.subnet_share_pattern, lookup(local.ssm_app_vars, local.network_model_changed ? "__dummy__" : "subnet_share_pattern", local.ssm_deploy_vars["default_subnet_share_pattern"])))
  subnet_share_alt              = nonsensitive(coalesce(var.subnet_share_alt == "<default>" ? null : var.subnet_share_alt, lookup(local.ssm_app_vars, local.network_model_changed ? "__dummy__" : "subnet_share_alt", lookup(local.defaults, "subnet_share_alt", "auto"))))
  flags_raw                     = nonsensitive(coalesce(var.flags == "<default>" ? null : var.flags, lookup(local.ssm_app_vars, "flags", lookup(local.defaults, local.network_model_changed ? "__dummy__" : "flags", "<none>"))))
  flags                         = [for f in split(",", local.flags_raw == "<none>" ? "" : local.flags_raw) : trimspace(f)]

  # Take into account AZ exclusion if it's still possible to reach the required AZ count (otherwise consider all *supported* AZs)
  supported_az_ids   = [for az_id in split(",", nonsensitive(local.ssm_deploy_vars["supported_availability_zones"])) : az_id if contains(data.aws_availability_zones.all.zone_ids, az_id)]
  filtered_az_ids    = [for az in local.supported_az_ids : az if !contains(local.az_exclusion, az)]
  available_az_ids   = local.az_count <= length(local.filtered_az_ids) ? local.filtered_az_ids : local.supported_az_ids
  available_az_names = sort([for az_id in local.available_az_ids : data.aws_availability_zones.all.names[index(data.aws_availability_zones.all.zone_ids, az_id)]])
  effective_az_names = slice(local.available_az_names, 0, local.az_count)

  # Compute resolved subnet share names and retrieve effective
  resolved_subnet_resource_share     = replace(replace(replace(replace(local.subnet_share_pattern, "%env_prefix%", local.prefix), "%alt_suffix%", ""), "%az_count%", local.az_count), "%confidentiality%", local.vpc_sensitivity == "standard" ? "" : "-${local.vpc_sensitivity}")
  resolved_subnet_resource_share_alt = replace(replace(replace(replace(local.subnet_share_pattern, "%env_prefix%", local.prefix), "%alt_suffix%", "-alt"), "%az_count%", local.az_count), "%confidentiality%", local.vpc_sensitivity == "standard" ? "" : "-${local.vpc_sensitivity}")

  # Check if subnet share setting has changed
  # If changed -> don't reuse the effective_subnet_share if any
  # If not changed -> ruse the effective_subnet_share if any to avoid accidentally switching share because conditions have changed
  previous_subnet_share_pattern = lookup(local.ssm_app_vars, "subnet_share_pattern", null)
  previous_subnet_share_alt     = lookup(local.ssm_app_vars, "subnet_share_alt", null)
  subnet_share_changed          = local.subnet_share_pattern != local.previous_subnet_share_pattern || local.subnet_share_alt != local.previous_subnet_share_alt
  effective_subnet_share        = nonsensitive(lookup(local.ssm_app_vars, local.network_model_changed || local.subnet_share_changed ? "__dummy__" : "effective_subnet_share", null))
}
