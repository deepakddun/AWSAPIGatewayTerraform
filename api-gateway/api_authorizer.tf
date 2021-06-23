resource "aws_api_gateway_authorizer" "cognito_user_pool" {
  name            = "api_gateway_authorizer"
  rest_api_id     = aws_api_gateway_rest_api.first_api.id
  identity_source = "method.request.header.Authorization"
  type            = "COGNITO_USER_POOLS"
  provider_arns   = [var.cognito_user_pool_arn]
}