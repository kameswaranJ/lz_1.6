resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  #checkov:skip=CKV_AWS_158:TODO setup KMS encryption
  provider = aws.app

  name              = "/stla/vpc-flow-logs/${var.name}/${aws_vpc.main.id}"
  retention_in_days = 7
}

resource "aws_flow_log" "flow_logs_cloudwatch" {
  provider = aws.app

  iam_role_arn         = var.flow_logs_role_arn
  log_destination_type = "cloud-watch-logs"
  log_destination      = aws_cloudwatch_log_group.vpc_flow_logs.arn
  log_format           = var.flow_logs_format
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.main.id

  tags = {
    Name = "vpf-${var.name}-all"
  }
}
