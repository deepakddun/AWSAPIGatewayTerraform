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
    key    = "api_gateway/terraform_api_gateway_s3.tf"
    region = "us-east-2"

    dynamodb_table = "terraform-up-and-running-locks-2"
    encrypt        = true
  }
}

resource "aws_s3_bucket" "api_gateway_product_bucket" {
  bucket = "api-gateway-product-bucket"
  acl    = "private"
  tags = {
    CreatedBy = "Terraform",
    Purpose   = "ProductLoad"
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "api_gateway_s3_public_access_block" {
  bucket                  = aws_s3_bucket.api_gateway_product_bucket.id
  restrict_public_buckets = true
  block_public_policy     = true
  block_public_acls       = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_object" "api_gateway_s3_bucket_object" {
  bucket                 = aws_s3_bucket.api_gateway_product_bucket.id
  key                    = "product_review.json"
  source                 = "${path.module}/review.json"
  server_side_encryption = "AES256"
  etag                   = filemd5("${path.module}/review.json")
}