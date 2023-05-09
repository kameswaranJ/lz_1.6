resource "aws_ram_principal_association" "frontend" {
  provider = aws.shared

  principal          = data.aws_caller_identity.app.account_id
  resource_share_arn = var.frontend_share_arn
}

# Hack to retrieve the shared frontend subnets
data "external" "frontend_subnets_ids_raw" {
  program = [
    "${path.module}/list_frontend.sh", data.aws_region.current.id, var.shared_role, var.frontend_share_arn
  ]
}

locals {
  frontend_subnet_ids = split(",", data.external.frontend_subnets_ids_raw.result.ids)
}

data "aws_subnet" "frontend_subnets" {
  provider = aws.shared
  for_each = toset(local.frontend_subnet_ids)

  id = each.value
}

data "aws_vpc" "main" {
  provider = aws.shared
  id       = data.aws_subnet.frontend_subnets[local.frontend_subnet_ids[0]].vpc_id
}

locals {
  effective_azs = [for frontend_subnet in data.aws_subnet.frontend_subnets : frontend_subnet.availability_zone]
}
