variable "application" {
  description = "Application name; e.g. cakes-service"
}

variable "env" {
  description = "Environment name; e.g. dev, prod"
}

variable "region" {
  description = "AWS region"
}

variable "cakes_api_ses_domain_identity" {
  description = "The domain name used for sending emails for Cakes API"
}

variable "cakes_api_cognito_from_email_address" {
  description = "A friendly name for the email sender in the format 'First Last <firstlast@example.com>'."
}
