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
    key    = "api_gateway/lambda_function/terraform_api_gateway_lambda_parallel_1.tfstate"
    region = "us-east-2"

    dynamodb_table = "terraform-up-and-running-locks-2"
    encrypt        = true

  }
}

data "archive_file" "zip_file" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_dependency_and_function"
  output_path = "${path.module}/lambda_dependency_and_function.zip"
}

resource "aws_lambda_function" "parallel_1_lambda" {
  filename      = "lambda_dependency_and_function.zip"
  function_name = "parallel_1"
  role          = data.aws_iam_role.lambda_role_name.arn
  handler       = "parallel_1.handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256(data.archive_file.zip_file.output_path)

  runtime = "python3.8"

/*  environment {
    variables = {
      STEP_ARN = "arn:aws:states:us-east-2:427128480243:stateMachine:my-state-machine"
    }
  }*/

  depends_on = [data.archive_file.zip_file]
}