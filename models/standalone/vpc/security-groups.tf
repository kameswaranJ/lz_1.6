resource "aws_security_group" "allow_tls" {
  #checkov:skip=CKV2_AWS_5:This security group is attached to interface endpoints
  provider    = aws.app
  name        = "aws-endpoint-traffic"
  description = "Reserved for internal LZ use in VPC ${aws_vpc.standalone.tags.Name}"
  vpc_id      = aws_vpc.standalone.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.standalone.cidr_block]
  }

  egress {
    description = "Any port to any host"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-${var.name}-aws-endpoint-traffic"
  }
}
