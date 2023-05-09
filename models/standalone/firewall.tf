data "aws_vpc_endpoint_service" "firewall" {
  provider = aws.hub

  service_name = var.fw_eps_name
}

resource "aws_vpc_endpoint_service_allowed_principal" "firewall" {
  provider = aws.hub

  vpc_endpoint_service_id = data.aws_vpc_endpoint_service.firewall.service_id
  principal_arn           = "arn:aws:iam::${data.aws_caller_identity.app.account_id}:root"
}
