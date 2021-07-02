provider "aws" {
  region = "us-east-2"
}


terraform {
  required_version = "> 0.14.0"
  required_providers {
    aws = "~> 3.0"
  }
}

data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

