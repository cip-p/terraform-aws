data "aws_ses_domain_identity" "domain_identity" {
  domain = var.cakes_api_ses_domain_identity
}
