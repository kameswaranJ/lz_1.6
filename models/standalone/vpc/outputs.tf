output vpc_id {
  value = aws_vpc.standalone.id
}

output fw_endpoints_ids {
  value = [for az, ep in aws_vpc_endpoint.fw_endpoint : ep.id]
}
