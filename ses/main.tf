locals {
  name_prefix = "${var.application}-${var.env}"
  tags = {
    Environment = var.env
    Terraform   = true
    infra-unit  = "ses-cakes-api"
  }
}

resource "aws_ses_domain_identity" "this" {
  domain = var.cakes_api_ses_domain_identity
}

resource "aws_ses_domain_dkim" "this" {
  domain = aws_ses_domain_identity.this.domain
}
