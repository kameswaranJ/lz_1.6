# DNS prod
moved {
  from = aws_route53_zone.prod[0]
  to   = aws_route53_zone.delegated[0]
}

moved {
  from = aws_route53_zone_association.prod_secondary[0]
  to   = aws_route53_zone_association.secondary
}

moved {
  from = aws_route53_vpc_association_authorization.prod[0]
  to   = aws_route53_vpc_association_authorization.forwarding
}

moved {
  from = aws_route53_zone_association.prod_forwarding[0]
  to   = aws_route53_zone_association.forwarding
}

# DNS non-prod
#moved {
#  from = aws_route53_zone.non_prod[0]
#  to   = aws_route53_zone.delegated[0]
#}
#
#moved {
#  from = aws_route53_zone_association.non_prod_secondary[0]
#  to   = aws_route53_zone_association.secondary
#}
#
#moved {
#  from = aws_route53_vpc_association_authorization.non_prod[0]
#  to   = aws_route53_vpc_association_authorization.forwarding
#}
#
#moved {
#  from = aws_route53_zone_association.non_prod_forwarding[0]
#  to   = aws_route53_zone_association.forwarding
#}
