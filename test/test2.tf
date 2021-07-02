resource "aws_api_gateway_rest_api" "api" {
  name        = "${var.api_gateway_name}-api"
  description = "${var.api_gateway_name} api"
  policy      = data.aws_iam_policy_document.api_policy_doc.json

  endpoint_configuration {
    types = [
      "REGIONAL"
    ]
  }
}

resource "aws_api_gateway_resource" "resource-public" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "public"
  depends_on = [aws_api_gateway_rest_api.api]
}

resource "aws_api_gateway_resource" "resource-public-sites" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_resource.resource-public.id
  path_part   = "sites"
  depends_on = [
    aws_api_gateway_resource.resource-public
  ]
}

resource "aws_api_gateway_method" "method-public-get-sites" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource-public.id
  http_method   = "GET"
  authorization = "NONE"
  depends_on = [
    aws_api_gateway_resource.resource-public-sites
  ]
}

resource "aws_api_gateway_method_response" "method-response-public-get-sites" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource-public-sites.id
  http_method = aws_api_gateway_method.method-public-get-sites.http_method
  status_code = "200"
  depends_on = [
    aws_api_gateway_method.method-public-get-sites
  ]
}

resource "aws_api_gateway_integration" "method-integration-public-get-sites" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource-public-sites.id
  http_method = aws_api_gateway_method.method-public-get-sites.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = var.lambda_invoke_arn
  depends_on = [
    aws_api_gateway_method.method-public-get-sites
  ]
}

resource "aws_api_gateway_integration_response" "integration-response-public-get-sites" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource-public.id
  http_method = aws_api_gateway_method.method-public-get-sites.http_method
  status_code = aws_api_gateway_method_response.method-response-public-get-sites.status_code

  depends_on = [
    aws_api_gateway_integration.method-integration-public-get-sites,
    aws_api_gateway_method_response.method-response-public-get-sites
  ]
}