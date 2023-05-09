output vpc_ids {
  value = [for vpc in module.vpc : vpc.vpc_id]
}

output fw_endpoints_ids {
  value = [for vpc in module.vpc : vpc.fw_endpoints_ids]
}
