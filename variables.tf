variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment name"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Common tags to apply to all resources"
}

# Cognito Variables
variable "cognito_pool_name" {
  type        = string
  default     = "my-user-pool"
  description = "Name of Cognito user pool"
}

variable "cognito_client_name" {
  type        = string
  default     = "my-app-client"
  description = "Name of Cognito user pool client"
}

variable "cognito_domain_prefix" {
  type        = string
  description = "Domain prefix for Cognito (must be globally unique)"
}

variable "resource_server_identifier" {
  type        = string
  default     = "api"
  description = "Identifier for resource server"
}

variable "resource_server_name" {
  type        = string
  default     = "My API"
  description = "Name of resource server"
}

# OAuth Variables
variable "callback_urls" {
  type        = list(string)
  default     = ["http://localhost:3000/callback"]
  description = "Allowed callback URLs"
}

variable "logout_urls" {
  type        = list(string)
  default     = ["http://localhost:3000/logout"]
  description = "Allowed logout URLs"
}

variable "default_redirect_uri" {
  type        = string
  default     = "http://localhost:3000/callback"
  description = "Default redirect URI"
}

# Test User Variables
variable "test_username" {
  type        = string
  default     = "testuser"
  description = "Test username"
}

variable "test_user_email" {
  type        = string
  default     = "test@example.com"
  description = "Test user email"
  sensitive   = true
}

variable "test_user_password" {
  type        = string
  description = "Test user password (meet complexity requirements)"
  sensitive   = true
}

# API Gateway Variables
variable "api_name" {
  type        = string
  default     = "secure-api"
  description = "Name of API Gateway"
}

variable "api_resource_path" {
  type        = string
  default     = "hello"
  description = "API resource path"
}

variable "http_method" {
  type        = string
  default     = "POST"
  description = "HTTP method for API"
}

variable "stage_name" {
  type        = string
  default     = "dev"
  description = "API Gateway stage name"
}

variable "authorizer_name" {
  type        = string
  default     = "cognito-authorizer"
  description = "Name of Cognito authorizer"
}

# Lambda Variables
variable "lambda_function_name" {
  type        = string
  default     = "secure-api-handler"
  description = "Name of Lambda function"
}

# Azure Entra ID Variables
variable "enable_azure_integration" {
  type        = bool
  default     = true
  description = "Enable Azure Entra ID integration with Cognito"
}

variable "azure_tenant_id" {
  type        = string
  description = "Azure Entra ID tenant ID (required if enable_azure_integration is true)"
  sensitive   = true
}