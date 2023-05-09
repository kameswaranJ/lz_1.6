# Move of VPC module
moved {
  from = module.vpc[0]
  to   = module.shared_vpc[0]
}

moved {
  from = module.shared_vpc[0]
  to   = module.shared_vpc
}

# DNS prod
moved {
  from = aws_route53_zone.prod[0]
  to   = aws_route53_zone.delegated[0]
}

moved {
  from = aws_route53_vpc_association_authorization.prod[0]
  to   = aws_route53_vpc_association_authorization.forwarding[0]
}

moved {
  from = aws_route53_zone_association.prod_forwarding[0]
  to   = aws_route53_zone_association.forwarding[0]
}

# DNS non-prod
#moved {
#  from = aws_route53_zone.non_prod[0]
#  to   = aws_route53_zone.delegated[0]
#}
#
#moved {
#  from = aws_route53_vpc_association_authorization.non_prod[0]
#  to   = aws_route53_vpc_association_authorization.forwarding[0]
#}
#
#moved {
#  from = aws_route53_zone_association.non_prod_forwarding[0]
#  to   = aws_route53_zone_association.forwarding[0]
#}
