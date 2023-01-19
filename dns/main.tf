locals {
  name_prefix = "${var.application}-${var.env}"
  tags = {
    Environment = var.env
    Terraform   = true
    infra-unit  = "dns"
  }
}

resource "aws_route53_zone" "root_domain" {
  name = var.root_public_domain

  tags = local.tags
}
