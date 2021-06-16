resource "aws_api_gateway_rest_api" "first_api" {
  name = "first-api"
  tags = {
    By = "Terraform"
  }
}