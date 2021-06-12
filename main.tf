provider "aws" {
  region = "us-east-2"
}


terraform {
  required_version = "> 0.14.0"
  required_providers {
    aws = "~> 3.0"
  }
}


resource "aws_api_gateway_rest_api" "first_api" {
  name = "first-api"
  tags = {
    By = "Terraform"
  }
}