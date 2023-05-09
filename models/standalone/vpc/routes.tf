resource "aws_route_table" "private" {
  provider = aws.app
  for_each = {for k, v in aws_subnet.private : k => v if can(regex("^0_", k))}  # Only one per-AZ
  vpc_id   = aws_vpc.standalone.id
  lifecycle {
    replace_triggered_by = [
      aws_vpc_endpoint.fw_endpoint
    ]
  }

  route {
    cidr_block      = "0.0.0.0/0"
    vpc_endpoint_id = aws_vpc_endpoint.fw_endpoint[each.value["availability_zone"]].id
  }

  tags = {
    Name = "rt-${var.name}-private-${each.value["availability_zone"]}"
  }
}

resource "aws_route_table_association" "private" {
  provider = aws.app
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private["0_${each.value.availability_zone}"].id
}

resource "aws_route_table" "public" {
  provider = aws.app
  for_each = aws_subnet.public
  lifecycle {
    replace_triggered_by = [
      aws_vpc_endpoint.fw_endpoint
    ]
  }

  vpc_id = aws_vpc.standalone.id

  route {
    cidr_block      = "0.0.0.0/0"
    vpc_endpoint_id = aws_vpc_endpoint.fw_endpoint[each.value.availability_zone].id
  }

  tags = {
    Name = "rt-${var.name}-public-${each.value.availability_zone}"
  }
}

resource "aws_route_table_association" "public" {
  provider = aws.app
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public[each.key].id
}

resource "aws_route_table" "firewall" {
  provider = aws.app

  vpc_id = aws_vpc.standalone.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "rt-${var.name}-firewall"
  }
}

resource "aws_route_table_association" "firewall" {
  provider = aws.app
  for_each = aws_subnet.firewall

  subnet_id      = each.value.id
  route_table_id = aws_route_table.firewall.id
}

resource "aws_route_table" "igw" {
  provider = aws.app
  vpc_id   = aws_vpc.standalone.id
  lifecycle {
    replace_triggered_by = [
      aws_vpc_endpoint.fw_endpoint,
      aws_subnet.firewall,
      aws_subnet.public
    ]
  }

  dynamic "route" {
    for_each = aws_subnet.public
    iterator = each

    content {
      cidr_block      = each.value.cidr_block
      vpc_endpoint_id = aws_vpc_endpoint.fw_endpoint[each.value.availability_zone].id
    }
  }

  dynamic "route" {
    for_each = toset(var.availability_zones)
    iterator = each

    content {
      cidr_block      = aws_subnet.firewall[each.value].cidr_block
      vpc_endpoint_id = aws_vpc_endpoint.fw_endpoint[each.value].id
    }
  }

  tags = {
    Name = "rt-${var.name}-igw"
  }
}

resource "aws_route_table_association" "igw" {
  provider = aws.app

  gateway_id     = aws_internet_gateway.igw.id
  route_table_id = aws_route_table.igw.id
}
