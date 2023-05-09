# Main variables

variable deploy_global_resources {
  type = bool
}

variable is_prod {
  type = bool
}

variable shared_role {
  type = string
}


variable app_role {
  type = string
}

variable fqName {
  type = string
}

variable app_default_tags {
  type = map(string)
}

# DNS variables

variable hosted_zone {
  type = string
}

variable domain_name {
  type = string
}

variable dns_forwarding_vpc_id {
  type = string
}

variable dns_forwarding_vpc_id_alt {
  type = string
}

# Subnet variables

variable subnet_resource_share {
  type = string
}

variable subnet_share_alt {
  type = string
}

variable effective_subnet_share {
  type = string
}

variable subnet_resource_share_alt {
  type = string
}

variable legacy_subnet_allocation {
  type = bool
}

variable backend_subnet_count {
  type = number
}

variable backend_netmask_length {
  type = number

  validation {
    condition     = var.backend_netmask_length <= 28
    error_message = "Backend subnet cannot be smaller than /28"
  }
}
