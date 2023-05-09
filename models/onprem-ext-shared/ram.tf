data "aws_ram_resource_share" "frontend" {
  provider = aws.shared

  name           = var.subnet_resource_share
  resource_owner = "SELF"
}

data "aws_ram_resource_share" "frontend_alt" {
  provider = aws.shared

  name           = var.subnet_resource_share_alt
  resource_owner = "SELF"
}

data "external" "count_frontend_ips" {
  program = [
    "${path.module}/count_ram_subnet_ips.sh", data.aws_region.current.id, var.shared_role,
    data.aws_ram_resource_share.frontend.arn
  ]
}

data "external" "count_frontend_ips_alt" {
  program = [
    "${path.module}/count_ram_subnet_ips.sh", data.aws_region.current.id, var.shared_role,
    data.aws_ram_resource_share.frontend_alt.arn
  ]
}

locals {
  nominal_ips_available  = tonumber(data.external.count_frontend_ips.result.count)
  alt_ips_available      = tonumber(data.external.count_frontend_ips_alt.result.count)
  frontend_arn           = data.aws_ram_resource_share.frontend.arn
  frontend_arn_alt       = data.aws_ram_resource_share.frontend_alt.arn
  subnet_share_alt       = var.subnet_share_alt == "auto" ? (local.nominal_ips_available > local.alt_ips_available ? false : true) : tobool(var.subnet_share_alt)
  effective_subnet_share = var.effective_subnet_share != null ? var.effective_subnet_share : (local.subnet_share_alt ? var.subnet_resource_share_alt : var.subnet_resource_share)
}

data "aws_ram_resource_share" "effective_share" {
  provider = aws.shared

  name           = local.effective_subnet_share
  resource_owner = "SELF"
}

resource "aws_ssm_parameter" "effective_subnet_share" {
  #checkov:skip=CKV2_AWS_34:Parameter value is not sensitive
  provider = aws.app

  name  = "/lz/tfvars/${var.fqName}/effective_subnet_share"
  type  = "String"
  value = local.effective_subnet_share
}
