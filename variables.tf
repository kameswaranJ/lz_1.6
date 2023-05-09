# General variables

variable app_id {
  type        = string
  description = "The identifier of the application"
}

variable env_type {
  type        = string
  description = "The environment type (prod, stage, ...)"
}

variable stla_region {
  type        = string
  description = "The Stellantis region to anchor the network (us-xf, eu-xp, ...)"
}

variable deploy_global_resources {
  type        = bool
  default     = null
  description = "If true, global resources (IAM roles, Route53 hosted zones, ...) are deployed. Set to true for first region then false for subsequent regions"
}

variable shared_role {
  type        = string
  description = "The role ARN allowing access to the account holding shared VPCs"
}

variable app_role {
  type        = string
  description = "The role ARN allowing access to target account (where resources will be deployed)"
}

variable allow_downgrade {
  type        = bool
  default     = false
  description = "Allow to deploy a version older than the one already deployed"
}

variable app_default_tags {
  type        = map(string)
  default     = {}
  description = "Tags that will be added on all resources deployed in the target account"
}

variable flags {
  type        = string
  default     = null
  description = "Feature flags to activate during deployment"
  validation {
    condition     = can(regex("^<default>|[^,(?! )]*$", coalesce(var.flags, "<default>")))
    error_message = "flags can only be omitted, '<default>' or a list of separated flag names"
  }
}

# Common network variables

variable hosted_zone {
  type        = string
  default     = null
  description = "The name of the parent Route53 hosted zone"
}


variable domain_name {
  type        = string
  default     = null
  description = "The name of the Route53 hosted zone dedicated to the application"
}


variable flow_logs_format {
  type        = string
  default     = null
  description = "VPC Flow Logs Format"
}

variable network_model {
  type        = string
  default     = null
  description = "Network model - standalone, on-prem-ext-shared, on-prem-ext-dedicated or none"
  validation {
    condition = contains([
      "<default>", "standalone", "onprem-ext-shared", "onprem-ext-dedicated", "none"
    ], coalesce(var.network_model, "<default>"))
    error_message = "network_model can only be omitted, '<default>', 'standalone', 'onprem-ext-shared, 'onprem-ext-dedicated', or 'none'"
  }
}

variable az_count {
  type        = string
  default     = null
  description = "The number of AZ to deploy to"
  validation {
    condition     = can(regex("^<default>|\\d+$", coalesce(var.az_count, "<default>")))
    error_message = "az_count can only be omitted, '<default>' or a positive integer"
  }
}

variable az_exclusion {
  type        = string
  default     = null
  description = "The comma-separated list of AZ ids (not AZ names) to exclude"
  validation {
    condition     = can(regex("^<default>|<none>|[a-z0-9-]+(,[a-z0-9-]+)*$", coalesce(var.az_exclusion, "<default>")))
    error_message = "az_exclusion can only be omitted, '<default>', '<none>' or a comma separated list of AZ"
  }
}

variable vpc_count {
  type        = string
  default     = null
  description = "Number of identical VPC(s) to create"
  validation {
    condition     = can(regex("^<default>|\\d+$", coalesce(var.vpc_count, "<default>")))
    error_message = "vpc_count can only be omitted, '<default>' or a positive integer"
  }
}

variable vpc_sensitivity {
  type        = string
  default     = null
  description = "Degree of data sensitivity for the VPC"
  validation {
    condition = contains([
      "<default>", "standard", "sensitive", "highly-sensitive"
    ], coalesce(var.vpc_sensitivity, "<default>"))
    error_message = "vpc_sensitivity can only be omitted, '<default>', 'standard', 'sensitive' or 'highly-sensitive'"
  }
}

variable frontend_netmask_length {
  type        = number
  default     = null
  description = "For all models, the size of a 'frontend' subnet (for 1 AZ)"

  validation {
    condition     = var.frontend_netmask_length == "<default>" || can(tonumber(var.frontend_netmask_length))
    error_message = "Frontend subnet can be <default> or a number"
  }
}

variable frontend_subnet_count {
  type        = string
  default     = null
  description = "For all models except standalone, the number of 'frontend' subnet(s) (for 1 AZ)"
  validation {
    condition     = can(regex("^<default>|\\d+$", coalesce(var.frontend_subnet_count, "<default>")))
    error_message = "frontend_subnet_count can only be omitted, '<default>' or a positive integer"
  }
}

variable backend_netmask_length {
  type        = number
  default     = null
  description = "For all models, the size of a 'backend' subnet (for 1 AZ)"
  validation {
    condition     = var.backend_netmask_length == "<default>" || can(tonumber(var.backend_netmask_length))
    error_message = "Frontend subnet can be <default> or a number"
  }
}

variable backend_subnet_count {
  type        = string
  default     = null
  description = "For all models, the number of 'backend' subnet(s) (for 1 AZ)"
  validation {
    condition     = can(regex("^<default>|\\d+$", coalesce(var.backend_subnet_count, "<default>")))
    error_message = "backend_subnet_count can only be omitted, '<default>' or a positive integer"
  }
}

# Dedicated on-prem extension variables

variable dedicated_backend_cidr {
  type        = string
  default     = null
  description = "For the onprem-ext-dedicated model, the CIDR to use for backend subnets if default is not suitable"
  validation {
    condition     = can(regex("^<default>|([0-9]{1,3}\\.){3}[0-9]{1,3}(\\/([0-9]|[1-2][0-9]|3[0-2]))?$", coalesce(var.dedicated_backend_cidr, "<default>")))
    error_message = "dedicated_backend_cidr can only be omitted, '<default>' or a valid CIDR"
  }
}

variable routed_backend_netmask_length {
  type        = number
  default     = null
  description = "For the onprem-ext-dedicated model, the size of a 'routed backend' subnet (for 1 AZ)"
  validation {
    condition     = var.routed_backend_netmask_length == "<default>" || can(tonumber(var.routed_backend_netmask_length))
    error_message = "routed_backend_netmask_length can be <default> or a number"
  }
}

variable routed_backend_subnet_count {
  type        = string
  default     = null
  description = "For the onprem-ext-dedicated model, the number of 'routed backend' subnet(s) (for 1 AZ)"
  validation {
    condition     = can(regex("^<default>|\\d+$", coalesce(var.routed_backend_subnet_count, "<default>")))
    error_message = "routed_backend_subnet_count can only be omitted, '<default>' or a positive integer"
  }
}

# Shared on-prem extension variables

variable subnet_share_pattern {
  type        = string
  default     = null
  description = "The pattern to use to select a suitable RAM share for deployment"
}

variable subnet_share_alt {
  type    = string
  default = null
  validation {
    condition     = contains(["<default>", "auto", "false", "true"], coalesce(var.subnet_share_alt, "<default>"))
    error_message = "subnet_share_alt can only be omitted, '<default>', 'auto', 'false' or 'true'"
  }
  description = "Choose a suitable RAM share automatically or statically select the normal or the alternate RAM share"
}
