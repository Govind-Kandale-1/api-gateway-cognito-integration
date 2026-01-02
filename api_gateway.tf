# REST API
resource "aws_api_gateway_rest_api" "main" {
  name = var.api_name
  
  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = var.tags
}

# Cognito Authorizer
resource "aws_api_gateway_authorizer" "cognito" {
  name            = var.authorizer_name
  rest_api_id     = aws_api_gateway_rest_api.main.id
  type            = "COGNITO_USER_POOLS"
  provider_arns   = [aws_cognito_user_pool.main.arn]
  identity_source = "method.request.header.Authorization"
}

# API Gateway Resource
resource "aws_api_gateway_resource" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = var.api_resource_path
}

# API Gateway Method
resource "aws_api_gateway_method" "main" {
  rest_api_id      = aws_api_gateway_rest_api.main.id
  resource_id      = aws_api_gateway_resource.main.id
  http_method      = var.http_method
  authorization    = "COGNITO_USER_POOLS"
  authorizer_id    = aws_api_gateway_authorizer.cognito.id
  request_models   = { "application/json" = aws_api_gateway_model.request_model.name }
}

# Request Model (for validation)
resource "aws_api_gateway_model" "request_model" {
  rest_api_id  = aws_api_gateway_rest_api.main.id
  name         = "RequestModel"
  content_type = "application/json"

  schema = jsonencode({
    type = "object"
    properties = {
      name = { type = "string" }
      message = { type = "string" }
    }
    required = ["name"]
  })
}

# Lambda Integration
resource "aws_api_gateway_integration" "lambda" {
  rest_api_id      = aws_api_gateway_rest_api.main.id
  resource_id      = aws_api_gateway_resource.main.id
  http_method      = aws_api_gateway_method.main.http_method
  type             = "AWS_PROXY"
  integration_http_method = "POST"
  uri              = aws_lambda_function.main.invoke_arn
}

# Integration Response
resource "aws_api_gateway_integration_response" "main" {
  rest_api_id       = aws_api_gateway_rest_api.main.id
  resource_id       = aws_api_gateway_resource.main.id
  http_method       = aws_api_gateway_method.main.http_method
  status_code       = "200"
}

# Method Response
resource "aws_api_gateway_method_response" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.main.id
  http_method = aws_api_gateway_method.main.http_method
  status_code = "200"

  response_models = { "application/json" = "Empty" }
}

# Deployment
resource "aws_api_gateway_deployment" "main" {
  depends_on = [aws_api_gateway_integration.lambda]

  rest_api_id = aws_api_gateway_rest_api.main.id

  lifecycle {
    create_before_destroy = true
  }
}

# API Gateway Stage
resource "aws_api_gateway_stage" "main" {
  rest_api_id      = aws_api_gateway_rest_api.main.id
  deployment_id    = aws_api_gateway_deployment.main.id
  stage_name       = var.stage_name

  tags = var.tags
}

# Stage Settings for Logging
resource "aws_api_gateway_stage_method_settings" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  stage_name  = aws_api_gateway_stage.main.stage_name
  method_path = "*/*"

  settings {
    logging_level = "INFO"
    data_trace_enabled = true
  }
}