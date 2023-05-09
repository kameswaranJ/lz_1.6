moved {
  from = aws_route53_zone.prod_sub[0]
  to   = aws_route53_zone.delegated[0]
}

moved {
  from = aws_route53_record.prod_sub_ns[0]
  to   = aws_route53_record.delegated_ns_records[0]
}

#moved {
#  from = aws_route53_zone.non_prod_sub[0]
#  to   = aws_route53_zone.delegated[0]
#}
#
#moved {
#  from = aws_route53_record.non_prod_sub_ns[0]
#  to   = aws_route53_record.delegated_ns_records[0]
#}
