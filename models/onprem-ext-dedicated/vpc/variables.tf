variable "stla_region" {
  type = string
}

variable "fqName" {
  type = string
}

variable name {
  type = string
}

variable availability_zones {
  type = list(string)
}

variable frontend_netmask_length {
  type = number
}

variable frontend_subnet_count {
  type = number
}

variable backend_cidr {
  type = string
}

variable backend_netmask_length {
  type = number
}

variable backend_subnet_count {
  type = number
}

variable routed_backend_subnet_count {
  type = number
}

variable routed_backend_netmask_length {
  type = number
}

variable flow_logs_format {
  type = string
}

variable tgw_id {
  type = string
}

variable tgw_share_name {
  type = string
}

variable dns_share_name {
  type = string
}

variable flow_logs_role_arn {
  type = string
}
