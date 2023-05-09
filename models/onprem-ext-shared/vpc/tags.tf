# TODO apply app default tags to frontend subnets (since its a shared resource, it is not modifiable anyway)
resource "aws_ec2_tag" "frontend_subnet" {
  provider   = aws.app
  for_each   = data.aws_subnet.frontend_subnets
  depends_on = [aws_ram_principal_association.frontend]

  resource_id = each.value.id
  key         = "Name"
  value       = "sn-${var.name}-frontend-${each.value.availability_zone}"
}

resource "aws_ec2_tag" "frontend_subnet_type" {
  provider   = aws.app
  for_each   = data.aws_subnet.frontend_subnets
  depends_on = [aws_ram_principal_association.frontend]

  resource_id = each.value.id
  key         = "subnet_type"
  value       = "frontend"
}

# TODO apply app default tags to backend subnets (since its a shared resource, it is not modifiable anyway)
resource "aws_ec2_tag" "backend_subnet" {
  provider   = aws.app
  for_each   = aws_subnet.backend
  depends_on = [aws_ram_resource_association.backend_subnet]

  resource_id = each.value.id
  key         = "Name"
  value       = each.value.tags.Name
}

resource "aws_ec2_tag" "backend_subnet_type" {
  provider   = aws.app
  for_each   = aws_subnet.backend
  depends_on = [aws_ram_resource_association.backend_subnet]

  resource_id = each.value.id
  key         = "subnet_type"
  value       = "backend"
}

resource "aws_ec2_tag" "vpc_defaults" {
  provider = aws.app
  for_each = var.app_default_tags

  resource_id = data.aws_vpc.main.id
  key         = each.key
  value       = each.value
}

resource "aws_ec2_tag" "vpc" {
  provider = aws.app

  resource_id = data.aws_vpc.main.id
  key         = "Name"
  value       = "vpc-${var.name}"
}

resource "aws_ec2_tag" "vpc_sensitivity" {
  provider = aws.app

  resource_id = data.aws_vpc.main.id
  key         = "sensitivity"
  value       = try(data.aws_vpc.main.tags.sensitivity, "")
}
