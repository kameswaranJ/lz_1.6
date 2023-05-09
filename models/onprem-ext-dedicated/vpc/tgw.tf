data "aws_ram_resource_share" "tgw" {
  provider = aws.hub

  name           = var.tgw_share_name
  resource_owner = "SELF"
}

resource "aws_ram_principal_association" "tgw" {
  provider = aws.hub

  principal          = data.aws_caller_identity.app.account_id
  resource_share_arn = data.aws_ram_resource_share.tgw.arn
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw" {
  provider   = aws.app
  depends_on = [aws_ram_principal_association.tgw]

  subnet_ids         = [for k, v in aws_subnet.frontend : v.id if can(regex("^0_", k))] # Only the first frontends
  transit_gateway_id = var.tgw_id
  vpc_id             = aws_vpc.main.id

  tags = {
    Name = "tga-${var.name}"
  }
}

moved {
  from = aws_ec2_transit_gateway_vpc_attachment.prod
  to   = aws_ec2_transit_gateway_vpc_attachment.tgw
}
