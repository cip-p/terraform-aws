locals {
  name_prefix = "${var.application}-${var.env}"
  tags = {
    Environment = var.env
    Terraform   = true
    infra-unit  = "cognito-cakes-api"
  }
}

resource "aws_cognito_user_pool" "this" {
  name = "${local.name_prefix}-cakes-api-user-pool"

  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
  }

  email_configuration {
    email_sending_account = "DEVELOPER"
    from_email_address    = var.cakes_api_cognito_from_email_address
    source_arn            = data.aws_ses_domain_identity.domain_identity.arn
  }

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true

    temporary_password_validity_days = 7
  }

  username_configuration {
    case_sensitive = false
  }

  lambda_config {
    custom_message = aws_lambda_function.custom_message.arn
  }

  tags = local.tags
}

resource "aws_cognito_user_pool_client" "this" {
  name         = "${local.name_prefix}-cakes-api-user-pool-client"
  user_pool_id = aws_cognito_user_pool.this.id

  generate_secret = true

  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]
}

resource "aws_lambda_permission" "custom_message" {
  statement_id  = "AllowExecutionFromCognito"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.custom_message.function_name
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = aws_cognito_user_pool.this.arn
  depends_on    = [aws_lambda_function.custom_message]
}

resource "aws_lambda_function" "custom_message" {
  function_name    = "${local.name_prefix}-cakes-api-cognito-custom-message-lambda"
  filename         = data.archive_file.lambda.output_path
  role             = aws_iam_role.custom_message_lambda.arn
  handler          = "cognito_custom_message_lambda.handler"
  source_code_hash = filebase64sha256(data.archive_file.lambda.output_path)
  runtime          = "nodejs16.x"

  tags = local.tags
}

data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "${path.module}/lambda"
  output_path = "lambda.zip"
}

resource "aws_iam_role" "custom_message_lambda" {
  name = "${local.name_prefix}-cakes-api-cognito-custom-message-lambda-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
