output "user_pool_id" {
  value       = aws_cognito_user_pool.main.id
  description = "Cognito User Pool ID"
}

output "user_pool_arn" {
  value       = aws_cognito_user_pool.main.arn
  description = "Cognito User Pool ARN"
}

output "user_pool_client_id" {
  value       = aws_cognito_user_pool_client.main.id
  description = "Cognito User Pool Client ID"
  sensitive   = true
}

output "cognito_domain" {
  value       = aws_cognito_user_pool_domain.main.domain
  description = "Cognito domain"
}

output "cognito_auth_endpoint" {
  value       = "https://${aws_cognito_user_pool_domain.main.domain}.auth.${var.aws_region}.amazoncognito.com"
  description = "Cognito authentication endpoint"
}

output "api_gateway_endpoint" {
  value       = aws_api_gateway_stage.main.invoke_url
  description = "API Gateway invoke URL"
}

output "api_gateway_id" {
  value       = aws_api_gateway_rest_api.main.id
  description = "API Gateway ID"
}

output "authorizer_id" {
  value       = aws_api_gateway_authorizer.cognito.id
  description = "Cognito Authorizer ID"
}

output "lambda_function_name" {
  value       = aws_lambda_function.main.function_name
  description = "Lambda function name"
}

output "lambda_function_arn" {
  value       = aws_lambda_function.main.arn
  description = "Lambda function ARN"
}

output "test_user_username" {
  value       = aws_cognito_user.test_user.username
  description = "Test user username"
}

output "curl_command_example" {
  value = "# Get token: aws cognito-idp admin-initiate-auth --region ${var.aws_region} --user-pool-id ${aws_cognito_user_pool.main.id} --client-id ${aws_cognito_user_pool_client.main.id} --auth-flow ADMIN_NO_SRP_AUTH --auth-parameters USERNAME=${aws_cognito_user.test_user.username},PASSWORD="
  description = "Example command to get authentication token"
}