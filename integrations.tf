module "reflex" {
  source = "git::https://github.intra.fcagroup.com/FCA-ICT/cto-cloud-aws-aft-network-reflex-07224.git?ref=v1.0.1"
  count  = contains(local.flags, "ENABLE_REFLEX_INTEGRATION") ? 1 : 0

  reflex_account  = local.ssm_deploy_vars["stla-technical-account-name"]
  reflex_password = local.ssm_deploy_vars["stla-technical-account-password"]
  account_id      = data.aws_caller_identity.app.account_id
  app_name        = local.app_info["app_name"]
  env_name        = local.app_info["env_name"]
}

module "palo_alto" {
  source    = "git::https://github.intra.fcagroup.com/FCA-ICT/cto-cloud-aws-aft-network-palo-alto-07224.git?ref=v1.0.0"
  count     = local.network_model == "standalone" && contains(local.flags, "ENABLE_PALO_ALTO_INTEGRATION") ? local.vpc_count : 0
  providers = {
    restapi = restapi.palo_alto
  }

  url     = local.ssm_deploy_vars["stla-fw-api-url"]
  headers = {
    Authorization   = "Basic ${base64encode("${local.ssm_deploy_vars["stla-technical-account-name"]}:${local.ssm_deploy_vars["stla-technical-account-password"]}")}"
    Content-Type    = "application/json"
    X-IBM-Client-ID = local.ssm_deploy_vars["stla-fw-api-client-id"]
  }
  fq_name      = "${local.fq_name}-${count.index}"
  account_id   = data.aws_caller_identity.app.account_id
  region       = data.aws_region.current.id
  endpoint_ids = [for az, id in module.standalone[0].fw_endpoints_ids[count.index] : id]
}
