aws_region = "us-east-1"
environment = "dev"

# Cognito Configuration
cognito_pool_name     = "my-app-pool"
cognito_client_name   = "my-app-client"
cognito_domain_prefix = "Demo-cognito-unique-6523Q-kjbh65hb3"  

# OAuth Configuration
callback_urls      = ["http://localhost:3000/callback"]
logout_urls        = ["http://localhost:3000/logout"]
default_redirect_uri = "http://localhost:3000/callback"

# Test User (Change password to meet complexity: min 8 chars, uppercase, lowercase, numbers, symbols)
test_username       = "testuser"
test_user_email     = "govind.kandale@roimaint.com"
test_user_password  = "aB9!Qx$7M@2k#Zp%rL8^S&dW5J*HcY0?"

# API Configuration
api_name    = "secure-api"
stage_name  = "dev"

# Lambda Configuration
lambda_function_name = "secure-api-handler"

# Tags
tags = {
  Environment = "dev"
  Project     = "SecureAPI"
  ManagedBy   = "Terraform"
  Owner       = "DevOps"
}

# Azure Entra ID Configuration
enable_azure_integration = true
azure_tenant_id          = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"  # Replace with your Azure tenant ID