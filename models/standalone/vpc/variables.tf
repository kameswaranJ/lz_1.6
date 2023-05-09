variable fq_name {
  type = string
}

variable name {
  type = string
}

variable cidr {
  type = string
}

variable availability_zones {
  type = list(string)
}

variable fw_eps_name {
  type = string
}

variable vpc_bit_shift {
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

variable tags {
  type = map(string)
}

variable flow_logs_format {
  type = string
}

variable endpoint_services {
  type = list(string)
}

variable flow_logs_role_arn {
  type = string
}

variable legacy_subnet_allocation {
  type = bool
}
