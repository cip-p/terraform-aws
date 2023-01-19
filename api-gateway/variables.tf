variable "application" {
  description = "Application name; e.g. cakes-service"
}

variable "env" {
  description = "Environment name; e.g. dev, prod"
}

variable "region" {
  description = "AWS region"
}

variable "api_gw_log_retention" {
  description = "Cloudwatch log groups log retention in days"
  default     = 14
}

variable "api_gw_stage_name" {
  default = "v1"
}

variable "cakes_api_gw_log_full_request_response_body" {
  description = "If the API Gateway to log the full HTTP request and response body. This should not be done in the production environment since it will log sensitive data, such as user passwords."
  type        = bool
}

variable "root_public_domain" {
  description = "Public domain"
}

variable "cakes_api_domain" {
  description = "Cakes API public domain"
}

variable "api_gw_authorizer_cakes_api_lambda_name" {
  description = "Name of the Cakes API Gateway lambda authorizer"
}
