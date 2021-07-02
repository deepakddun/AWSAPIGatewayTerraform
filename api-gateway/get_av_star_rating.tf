resource "aws_api_gateway_resource" "get_av_rating" {
  parent_id   = aws_api_gateway_rest_api.first_api.root_resource_id
  path_part   = "get_av_rating"
  rest_api_id = aws_api_gateway_rest_api.first_api.id
}

# Lambda permission
resource "aws_lambda_permission" "apigw_lambda_get_av_star_rating" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.get_average_rating_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.first_api.id}/*/${aws_api_gateway_method.get_av_rating_method.http_method}${aws_api_gateway_resource.get_av_rating.path}"
}

resource "aws_api_gateway_method" "get_av_rating_method" {

  rest_api_id   = aws_api_gateway_rest_api.first_api.id
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.get_av_rating.id
  authorization = "NONE"
  request_parameters = {
    "method.request.querystring.product_id" : false
  }
}


resource "aws_api_gateway_integration" "get_av_rating_integration" {
  http_method = aws_api_gateway_method.get_av_rating_method.http_method
  resource_id = aws_api_gateway_resource.get_av_rating.id
  rest_api_id = aws_api_gateway_rest_api.first_api.id
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-2:427128480243:function:get_average_rating_lambda/invocations"
  request_templates = {
    "application/json" = jsonencode({
      "product_id_str": "$input.params().querystring.get('product_id')"
    })
  }
  passthrough_behavior = "WHEN_NO_TEMPLATES"
}

resource "aws_api_gateway_integration_response" "get_av_rating_integration_response" {
  http_method = "GET"
  resource_id = aws_api_gateway_resource.get_av_rating.id
  rest_api_id = aws_api_gateway_rest_api.first_api.id
  status_code = 200
  response_templates = {
    "application/json" = ""
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" : "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" : "'GET'",
    "method.response.header.Access-Control-Allow-Origin" : "'*'"
  }
  depends_on = [aws_api_gateway_integration.get_av_rating_integration, aws_api_gateway_method.get_av_rating_method,
  aws_api_gateway_method_response.get_av_rating_method_response]
}

resource "aws_api_gateway_method_response" "get_av_rating_method_response" {
  http_method = aws_api_gateway_method.get_av_rating_method.http_method
  resource_id = aws_api_gateway_resource.get_av_rating.id
  rest_api_id = aws_api_gateway_rest_api.first_api.id
  status_code = 200
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" : false,
    "method.response.header.Access-Control-Allow-Origin" : false,
    "method.response.header.Access-Control-Allow-Methods" : false
  }
  depends_on = [aws_api_gateway_integration.get_av_rating_integration, aws_api_gateway_method.get_av_rating_method]
}