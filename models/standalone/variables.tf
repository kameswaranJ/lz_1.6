variable deploy_global_resources {
  type = bool
}

variable "fqName" {
  type = string
}

variable "is_prod" {
  type = bool
}

variable available_az_ids {
  type = list(string)
}

variable az_count {
  type = number
}

variable fw_eps_name {
  type = string
}

variable domain_name {
  type = string
}

variable hosted_zone {
  type = string
}

variable tags {
  type = map(string)
}

variable endpoint_services {
  type = list(string)
}

variable vpc_count {
  type = number
}

variable frontend_netmask_length {
  type = number
}

variable backend_subnet_count {
  type = number
}

variable backend_netmask_length {
  type = number
}

variable flow_logs_format {
  type = string
}

variable flow_logs_role_arn {
  type = string
}

variable legacy_subnet_allocation {
  type = bool
}
