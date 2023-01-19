application                                 = "cakes-service"
env                                         = "dev"
region                                      = "us-east-1"
root_public_domain                          = "my-cakes-api-hostname.com"
cakes_api_domain                            = "api.dev.my-cakes-api-hostname.com"
api_gw_authorizer_cakes_api_lambda_name     = "api-gw-authorizer-cakes-api"
cakes_api_gw_log_full_request_response_body = false
cakes_api_ses_domain_identity               = "my-cakes-api-hostname.com"
cakes_api_cognito_from_email_address        = "cakes company <donotreplydev@my-cakes-api-hostname.com>"
cakes_api_max_concurrency                   = 100
cakes_api_max_size                          = 2
cakes_api_min_size                          = 1
ecr_account_id                              = "aws_account_id"
ecr_services = [
  "cakes-api",
]
