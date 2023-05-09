terraform {
  required_providers {
    aws = {
      configuration_aliases = [aws.app, aws.deploy]
    }
  }
}
