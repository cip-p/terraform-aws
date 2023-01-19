locals {
  name_prefix = "${var.application}-${var.env}"
}

resource "aws_api_gateway_account" "this" {
  cloudwatch_role_arn = aws_iam_role.cloudwatch_api_gw.arn
}

data "template_file" "cloudwatch_api_gw_role_template" {
  template = file("${path.module}/templates/cloudwatch-api-gw-role.tpl")
}

resource "aws_iam_role" "cloudwatch_api_gw" {
  name = "${local.name_prefix}-cloudwatch-api-gw-role"

  assume_role_policy = data.template_file.cloudwatch_api_gw_role_template.rendered
}

data "template_file" "cloudwatch_api_gw_policy_template" {
  template = file("${path.module}/templates/cloudwatch-api-gw-policy.tpl")
}

resource "aws_iam_role_policy" "cloudwatch_api_gw" {
  name = "${local.name_prefix}-cloudwatch-api-gw-policy"
  role = aws_iam_role.cloudwatch_api_gw.id

  policy = data.template_file.cloudwatch_api_gw_policy_template.rendered
}
