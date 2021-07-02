variable "cognito_user_pool_arn" {
  type    = string
  default = "arn:aws:cognito-idp:us-east-2:427128480243:userpool/us-east-2_6MhQCOHuG"
}

data "aws_cognito_user_pools" "cognito_user_pools" {
  name = "FancyPool2"
}

variable "get_reviews_lambda_function" {
  type    = string
  default = "get_reviews"
}

data "aws_lambda_function" "get_reviews_lambda" {
  function_name = "get_reviews"
}

data "aws_lambda_function" "get_average_rating_lambda" {
  function_name = "get_average_rating_lambda"
}

data "aws_lambda_function" "create_report_lambda" {
  function_name = "create_report"
}

data "aws_caller_identity" "current" {}

//variable "account_id" {
//  type = number
//  default = data.aws_caller_identity.current.account_id
//}

variable "region" {
  type    = string
  default = "us-east-2"
}