resource "aws_api_gateway_resource" "create_report" {
  parent_id   = aws_api_gateway_rest_api.first_api.root_resource_id
  path_part   = "create_report"
  rest_api_id = aws_api_gateway_rest_api.first_api.id
}

resource "aws_api_gateway_method" "create_report_method" {

  rest_api_id   = aws_api_gateway_rest_api.first_api.id
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.create_report.id
  authorization = "NONE"
}


resource "aws_api_gateway_integration" "create_report_integration" {
  http_method = aws_api_gateway_method.create_report_method.http_method
  resource_id = aws_api_gateway_resource.create_report.id
  rest_api_id = aws_api_gateway_rest_api.first_api.id
  type        = "MOCK"
  request_templates = {
    "application/json" = jsonencode({
      statusCode = 200
    })
  }
}

resource "aws_api_gateway_integration_response" "create_report_integration_response" {
  http_method = "POST"
  resource_id = aws_api_gateway_resource.create_report.id
  rest_api_id = aws_api_gateway_rest_api.first_api.id
  status_code = 200
  response_templates = {
    "application/json" = jsonencode({

      "message_str" : "report requested, check your phone shortly"

    })
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" : "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" : "'POST'",
    "method.response.header.Access-Control-Allow-Origin" : "'*'",
  }
  depends_on = [aws_api_gateway_integration.create_report_integration , aws_api_gateway_method_response.create_report_method_response]
}

resource "aws_api_gateway_method_response" "create_report_method_response" {
  http_method = "POST"
  resource_id = aws_api_gateway_resource.create_report.id
  rest_api_id = aws_api_gateway_rest_api.first_api.id
  status_code = 200
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" : false,
    "method.response.header.Access-Control-Allow-Origin" : false,
    "method.response.header.Access-Control-Allow-Methods" : false
  }
  depends_on = [aws_api_gateway_method.create_report_method, aws_api_gateway_integration.create_report_integration]
}


// options method
resource "aws_api_gateway_method" "create_report_options_method" {
  http_method   = "OPTIONS"
  resource_id   = aws_api_gateway_resource.create_report.id
  rest_api_id   = aws_api_gateway_rest_api.first_api.id
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "create_report_options_integration" {
  http_method = aws_api_gateway_method.create_report_options_method.http_method
  resource_id = aws_api_gateway_resource.create_report.id
  rest_api_id = aws_api_gateway_rest_api.first_api.id
  type        = "MOCK"
  request_templates = {
    "application/json" = jsonencode({
      statusCode = 200
    })
  }
}

resource "aws_api_gateway_method_response" "create_report_method_options_response" {
  http_method = "OPTIONS"
  resource_id = aws_api_gateway_resource.create_report.id
  rest_api_id = aws_api_gateway_rest_api.first_api.id
  status_code = 200
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" : true,
    "method.response.header.Access-Control-Allow-Origin" : true,
    "method.response.header.Access-Control-Allow-Methods" : true,
    "method.response.header.Access-Control-Allow-Credentials" : true
  }
  response_models = {
    "application/json" = "Empty"
  }

  depends_on = [aws_api_gateway_method.create_report_options_method, aws_api_gateway_integration.create_report_options_integration]
}

resource "aws_api_gateway_integration_response" "create_report_integration_options_response" {
  http_method = "OPTIONS"
  resource_id = aws_api_gateway_resource.create_report.id
  rest_api_id = aws_api_gateway_rest_api.first_api.id
  status_code = 200
  response_templates = {

  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" : "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" : "'POST,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin" : "'*'",
    "method.response.header.Access-Control-Allow-Credentials" : "'true'"
  }
  depends_on = [aws_api_gateway_method.create_report_options_method, aws_api_gateway_integration.create_report_options_integration
  , aws_api_gateway_method_response.create_report_method_options_response]
}