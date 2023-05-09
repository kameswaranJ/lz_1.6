locals {
  dns_zone_name = var.is_prod ? "${var.domain_name}.${var.hosted_zone}" : "${var.domain_name}.np.${var.hosted_zone}"
}

# In the case of a shared VPC, we need a dummy VPC to create the Route53 zone. It can be cleaned up afterwards and
# will be destroyed on subsequent Terraform runs if remaining
resource "aws_vpc" "dummy" {
  #checkov:skip=CKV2_AWS_11:This is a temporary VPC so no VPC flow logs
  provider = aws.app
  count    = var.deploy_global_resources ? 1 : 0

  cidr_block           = "192.168.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "vpc-${var.fqName}-dummy-do-not-use"
  }
}

resource "aws_default_security_group" "default" {
  provider = aws.app
  count    = var.deploy_global_resources ? 1 : 0

  vpc_id = aws_vpc.dummy[0].id
}

resource "aws_route53_zone" "delegated" {
  #checkov:skip=CKV2_AWS_38:This is not a public DNS hosted zone, so no DNSSEC
  #checkov:skip=CKV2_AWS_39:TODO setup DNS query logging
  provider   = aws.app
  count      = var.deploy_global_resources ? 1 : 0
  depends_on = [module.shared_vpc]

  lifecycle {
    ignore_changes = [
      vpc
    ]
  }

  name    = local.dns_zone_name
  comment = "Delegated zone for ${var.fqName}, managed by Terraform"

  vpc {
    vpc_id = aws_vpc.dummy[0].id
  }
}

data "aws_route53_zone" "delegated" {
  provider = aws.app
  count    = var.deploy_global_resources ? 0 : 1

  name         = local.dns_zone_name
  private_zone = true
}

locals {
  dns_zone_id = var.deploy_global_resources ? aws_route53_zone.delegated[0].id : data.aws_route53_zone.delegated[0].zone_id
}

resource "aws_route53_vpc_association_authorization" "shared" {
  provider = aws.app

  vpc_id  = module.shared_vpc.vpc_id
  zone_id = local.dns_zone_id
}

resource "aws_route53_zone_association" "shared" {
  provider = aws.shared

  zone_id = aws_route53_vpc_association_authorization.shared.zone_id
  vpc_id  = aws_route53_vpc_association_authorization.shared.vpc_id
}

resource "aws_route53_vpc_association_authorization" "forwarding" {
  provider = aws.app
  count    = var.deploy_global_resources ? 1 : 0

  vpc_id  = var.dns_forwarding_vpc_id
  zone_id = local.dns_zone_id
}

resource "aws_route53_zone_association" "forwarding" {
  provider = aws.hub
  count    = var.deploy_global_resources ? 1 : 0

  vpc_id  = aws_route53_vpc_association_authorization.forwarding[0].vpc_id
  zone_id = aws_route53_vpc_association_authorization.forwarding[0].zone_id
}

resource "aws_route53_vpc_association_authorization" "forwarding_alt" {
  provider = aws.app
  count    = var.dns_forwarding_vpc_id != var.dns_forwarding_vpc_id_alt && var.deploy_global_resources ? 1 : 0

  vpc_id     = var.dns_forwarding_vpc_id_alt
  zone_id    = local.dns_zone_id
  vpc_region = data.aws_region.alt.id
}

resource "aws_route53_zone_association" "forwarding_alt" {
  provider = aws.hub_alt
  count    = var.dns_forwarding_vpc_id != var.dns_forwarding_vpc_id_alt && var.deploy_global_resources ? 1 : 0

  vpc_id  = aws_route53_vpc_association_authorization.forwarding_alt[0].vpc_id
  zone_id = aws_route53_vpc_association_authorization.forwarding_alt[0].zone_id
}
