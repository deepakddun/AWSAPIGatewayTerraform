provider "aws" {
  region = "us-east-2"

}

terraform {
  required_providers {
    aws = "~> 3.0"
  }
  required_version = " > 0.14"

  backend "s3" {
    bucket = "nyeisterraformstatedata2"
    key    = "api_gateway/common_role/terraform_api_gateway_lambda_role.tf"
    region = "us-east-2"

    dynamodb_table = "terraform-up-and-running-locks-2"
    encrypt        = true
  }
}

data "aws_s3_bucket" "bucket_name" {
  bucket = var.bucket_name
}

locals {
  bucket_name = data.aws_s3_bucket.bucket_name.arn
}

resource "aws_iam_role" "common_lambda_role" {
  name = "common_lambda_role_s3_api_gateway"
  assume_role_policy = jsonencode(
    {
      Version : "2012-10-17",
      Statement : [
        {
          Action : "sts:AssumeRole",
          Principal : {
            Service : "lambda.amazonaws.com"
          },
          Effect : "Allow",
          Sid : ""
        }
      ]
    }
  )
}

resource "aws_iam_policy" "common_lambda_policy" {
  name = "common_lambda_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:List*",
          "s3:Put*",
          "s3:Get*"
        ]
        Effect = "Allow"
        Resource = [
          "${local.bucket_name}",
          "${local.bucket_name}/*",
        ]
      },
    ]


  })
}

resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  policy_arn = aws_iam_policy.common_lambda_policy.arn
  role       = aws_iam_role.common_lambda_role.name
}