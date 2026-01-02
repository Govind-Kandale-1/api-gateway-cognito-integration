# Cognito User Pool
resource "aws_cognito_user_pool" "main" {
  name                     = var.cognito_pool_name
  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  schema {
    attribute_data_type = "String"
    name = "email"
    mutable        = true
    required       = true
  }

  mfa_configuration = "OPTIONAL"

  tags = var.tags
}

# User Pool Client (with OAuth flows)
resource "aws_cognito_user_pool_client" "main" {
  name                = var.cognito_client_name
  user_pool_id        = aws_cognito_user_pool.main.id
  explicit_auth_flows = ["ALLOW_ADMIN_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
  
  supported_identity_providers = ["COGNITO", "AzureAD"]
  
  allowed_oauth_flows            = ["code", "implicit"]
  allowed_oauth_scopes           = ["email", "openid", "profile", "aws.cognito.signin.user.admin"]
  allowed_oauth_flows_user_pool_client = true
  
  callback_urls           = var.callback_urls
  logout_urls             = var.logout_urls
  default_redirect_uri    = var.default_redirect_uri
  
  access_token_validity  = 1
  refresh_token_validity = 30
  id_token_validity      = 1
  token_validity_units {
    access_token  = "hours"
    id_token      = "hours"
    refresh_token = "days"
  }

  prevent_user_existence_errors = "ENABLED"

}

# Resource Server (for scopes)
resource "aws_cognito_resource_server" "main" {
  identifier   = var.resource_server_identifier
  name         = var.resource_server_name
  user_pool_id = aws_cognito_user_pool.main.id

  scope {
    scope_name        = "read"
    scope_description = "Read access to API"
  }

  scope {
    scope_name        = "write"
    scope_description = "Write access to API"
  }

  scope {
    scope_name        = "admin"
    scope_description = "Admin access to API"
  }
}

# Domain for Cognito UI
resource "aws_cognito_user_pool_domain" "main" {
  domain       = var.cognito_domain_prefix
  user_pool_id = aws_cognito_user_pool.main.id
}

# Test User (for testing)
resource "aws_cognito_user" "test_user" {
  user_pool_id = aws_cognito_user_pool.main.id
  username     = var.test_username
  password     = var.test_user_password
  
  attributes = {
    email            = var.test_user_email
    email_verified   = "true"
  }

  message_action = "SUPPRESS"

  depends_on = [aws_cognito_user_pool.main]
}

# Azure Entra ID (SAML) Identity Provider
resource "aws_cognito_identity_provider" "azure_saml" {
  count             = var.enable_azure_integration ? 1 : 0
  user_pool_id      = aws_cognito_user_pool.main.id
  provider_name     = "AzureAD"
  provider_type     = "SAML"

  provider_details = {
    MetadataURL = "https://login.microsoftonline.com/${var.azure_tenant_id}/federationmetadata/2007-06/federationmetadata.xml"
  }

  attribute_mapping = {
    email       = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"
    name        = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname"
    given_name  = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname"
    family_name = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname"
  }
}