data "aws_ram_resource_share" "dns_forwarding" {
  provider = aws.hub

  name           = var.dns_share_name
  resource_owner = "SELF"
}

resource "aws_ram_principal_association" "dns_forwarding" {
  provider = aws.hub

  principal          = data.aws_caller_identity.app.account_id
  resource_share_arn = data.aws_ram_resource_share.dns_forwarding.arn
}

data "aws_route53_resolver_rules" "shared_rules" {
  provider = aws.hub

  rule_type    = "FORWARD"
  share_status = "SHARED_BY_ME"
}

resource "aws_route53_resolver_rule_association" "fwd" {
  provider   = aws.app
  for_each   = data.aws_route53_resolver_rules.shared_rules.resolver_rule_ids
  depends_on = [aws_ram_principal_association.dns_forwarding]

  resolver_rule_id = each.value
  vpc_id           = aws_vpc.main.id
  name             = aws_vpc.main.tags.Name
}
