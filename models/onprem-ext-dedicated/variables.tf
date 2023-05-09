# Main variables

variable "stla_region" {
  type = string
}

variable availability_zones {
  type = list(string)
}

variable deploy_global_resources {
  type = bool
}

variable shared_role {
  type = string
}

variable fqName {
  type = string
}

variable is_prod {
  type = bool
}

variable app_default_tags {
  type = map(string)
}

# VPC variables

variable vpc_count {
  type = number
}

variable backend_cidr {
  type = string
}

variable flow_logs_format {
  type = string
}

variable flow_logs_role_arn {
  type = string
}

variable tgw_share_name {
  type = string
}

variable tgw_id {
  type = string
}

# DNS variables

variable hosted_zone {
  type = string
}

variable domain_name {
  type = string
}

variable dns_forward_share {
  type = string
}

variable dns_forwarding_vpc_id {
  type = string
}

variable dns_forwarding_vpc_id_alt {
  type = string
}

# Subnet variables

variable frontend_netmask_length {
  type = number

  validation {
    condition     = var.frontend_netmask_length <= 28
    error_message = "Frontend subnet cannot be smaller than /28"
  }
}

variable frontend_subnet_count {
  type = number
}

variable backend_netmask_length {
  type = number

  validation {
    condition     = var.backend_netmask_length <= 28
    error_message = "Backend subnet cannot be smaller than /28"
  }
}

variable backend_subnet_count {
  type = number
}

variable routed_backend_netmask_length {
  type = number
  validation {
    condition     = var.routed_backend_netmask_length <= 28
    error_message = "Backend subnet cannot be smaller than /28"
  }
}

variable routed_backend_subnet_count {
  type = number
}
