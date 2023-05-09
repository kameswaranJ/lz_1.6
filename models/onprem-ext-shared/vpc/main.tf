terraform {
  required_providers {
    aws = {
      configuration_aliases = [aws.app, aws.hub, aws.shared, aws.shared_core]
    }
  }
}

data "aws_caller_identity" "shared" {
  provider = aws.shared
}

data "aws_caller_identity" "app" {
  provider = aws.app
}

data "aws_region" "current" {
  provider = aws.app
}