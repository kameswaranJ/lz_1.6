locals {
  parent_zone = "${var.is_prod ? "" : "np."}${var.hosted_zone}"
  zone_name   = "${var.domain_name}.${local.parent_zone}"
}

data "aws_route53_zone" "parent" {
  provider = aws.hub

  name = local.parent_zone
}

resource "aws_route53_zone" "delegated" {
  #checkov:skip=CKV2_AWS_38:TODO setup DNSSEC
  #checkov:skip=CKV2_AWS_39:TODO setup DNS query logging
  provider = aws.app
  count    = var.deploy_global_resources ? 1 : 0

  name    = local.zone_name
  comment = "Delegated zone for ${var.fqName}, managed by LZ"
}

resource "aws_route53_record" "delegated_ns_records" {
  provider = aws.hub
  count    = var.deploy_global_resources ? 1 : 0

  zone_id = data.aws_route53_zone.parent.zone_id
  name    = var.domain_name
  type    = "NS"
  ttl     = "300"
  records = [
  for awsns in aws_route53_zone.delegated[0].name_servers :
  "${awsns}."
  ]
}
