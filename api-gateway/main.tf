provider "aws" {
  region = "us-east-2"
}


terraform {
  required_version = "> 0.14.0"
  required_providers {
    aws = "~> 3.0"
  }
  backend "s3" {
    bucket = "nyeisterraformstatedata2"
    key    = "api_gateway/terraform_api_gateway.tfstate"
    region = "us-east-2"

    dynamodb_table = "terraform-up-and-running-locks-2"
    encrypt        = true
  }
}

