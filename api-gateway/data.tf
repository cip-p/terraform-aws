data "aws_lambda_function" "authorizer" {
  function_name = "${local.name_prefix}-${var.api_gw_authorizer_cakes_api_lambda_name}"
}

data "aws_route53_zone" "root_domain" {
  name         = var.root_public_domain
  private_zone = false
}
