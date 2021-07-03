/*variable "lambda_role_name" {
  type = string
  default = "common_lambda_role_s3_api_gateway"
}*/

data "aws_iam_role" "lambda_role_name" {
  name = "common_lambda_role_s3_api_gateway_2"
}