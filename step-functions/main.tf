provider "aws" {
  region = "us-east-2"
}

terraform {
  required_version = "> 0.12.0"
  required_providers {
    aws = "~> 3.0"
  }

  backend "s3" {
    bucket = "nyeisterraformstatedata2"
    key    = "api_gateway/step=functions/terraform_api_gateway_step_functions.tfstate"
    region = "us-east-2"

    dynamodb_table = "terraform-up-and-running-locks-2"
    encrypt        = true
  }
}