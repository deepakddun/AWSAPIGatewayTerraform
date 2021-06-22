resource "aws_api_gateway_resource" "get_av_rating" {
  parent_id   = aws_api_gateway_rest_api.first_api.root_resource_id
  path_part   = "get_av_rating"
  rest_api_id = aws_api_gateway_rest_api.first_api.id
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
  type        = "MOCK"
  request_templates = {
    "application/json" = jsonencode({
      statusCode = 200
    })
  }
}

resource "aws_api_gateway_integration_response" "get_av_rating_integration_response" {
  http_method = "GET"
  resource_id = aws_api_gateway_resource.get_av_rating.id
  rest_api_id = aws_api_gateway_rest_api.first_api.id
  status_code = 200
  response_templates = {
    "application/json" = jsonencode({

      "product_id_str" : "$input.params('product_id')",
      "average_star_review_float" : 3.25

    })


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
  http_method = "GET"
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