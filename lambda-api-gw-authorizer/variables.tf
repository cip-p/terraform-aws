variable "application" {
  description = "Application name; e.g. cakes-service"
}

variable "env" {
  description = "Environment name; e.g. dev, prod"
}

variable "region" {
  description = "AWS region"
}

variable "api_gw_authorizer_cakes_api_lambda_name" {
  description = "Name of the Cakes API Gateway lambda authorizer"
}

variable "lambda_memory" {
  type    = number
  default = 512
}

variable "lambda_timeout" {
  type    = number
  default = 10
}
