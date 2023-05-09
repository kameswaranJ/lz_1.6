data "aws_region" "current" {
  provider = aws.app
}

data "aws_caller_identity" "app" {
  provider = aws.app
}

resource "aws_vpc_endpoint" "s3" {
  provider          = aws.app
  vpc_id            = aws_vpc.standalone.id
  service_name      = "com.amazonaws.${data.aws_region.current.id}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = concat([for rt in aws_route_table.public : rt.id], [for rt in aws_route_table.private :rt.id])

  tags = {
    Name = "ep-${var.name}-s3"
  }
}

locals {
  endpoints = ["ecr.api", "ecr.dkr", "secretsmanager", "ssm", "ssmmessages", "ec2messages", "monitoring", "events", "logs"]
}

resource "aws_vpc_endpoint" "aws" {
  provider = aws.app
  for_each = toset(local.endpoints)
  lifecycle {
    ignore_changes = [
      service_name # If removed, endpoints are always re-created for dubious reasons
    ]
  }

  vpc_id              = aws_vpc.standalone.id
  service_name        = "com.amazonaws.${data.aws_region.current.id}.${each.value}"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  tags = {
    Name = "ep-${var.name}-${replace(each.value, ".", "-")}"
  }
}

resource "aws_vpc_endpoint_subnet_association" "aws_sn" {
  provider = aws.app
  for_each = {
  for i in setproduct(local.endpoints, var.availability_zones) : format("%s_%s", i[0], i[1]) => {
    endpoint : i[0],
    az : i[1]
  } if contains(keys(aws_subnet.private), "0_${i[1]}")
  }

  vpc_endpoint_id = aws_vpc_endpoint.aws[each.value["endpoint"]].id
  subnet_id       = aws_subnet.private["0_${each.value["az"]}"].id
}

resource "aws_vpc_endpoint_security_group_association" "aws_sg" {
  provider = aws.app
  for_each = toset(local.endpoints)

  vpc_endpoint_id             = aws_vpc_endpoint.aws[each.value].id
  security_group_id           = aws_security_group.allow_tls.id
  replace_default_association = true
}

resource "aws_vpc_endpoint_service_allowed_principal" "stla" {
  provider = aws.hub
  for_each = toset(var.endpoint_services)

  vpc_endpoint_service_id = each.value
  principal_arn           = "arn:aws:iam::${data.aws_caller_identity.app.account_id}:root"
}
