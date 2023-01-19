locals {
  name_prefix = "${var.application}-${var.env}"
  tags = {
    Environment = var.env
    Terraform   = true
    infra-unit  = "lambda-api-gw-authorizer-cakes-api"
  }
}

resource "aws_lambda_function" "this" {
  function_name = "${local.name_prefix}-${var.api_gw_authorizer_cakes_api_lambda_name}"
  runtime       = "nodejs16.x"
  handler       = "src/auth.authorize"
  role          = aws_iam_role.lambda_exec.arn
  memory_size   = var.lambda_memory
  timeout       = var.lambda_timeout
  filename      = "dummy-function.zip" // just for the initial creation, lambda is deployed independently

  environment {
    variables = {
      dummy = "terraform-environment-variable-used-for-initialisation-only"
    }
  }

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      # manually set in the AWS console
      environment.0.variables
    ]
  }

  tags = local.tags
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "/aws/lambda/${aws_lambda_function.this.function_name}"

  retention_in_days = 30
}

resource "aws_iam_role" "lambda_exec" {
  name = "${local.name_prefix}-${var.api_gw_authorizer_cakes_api_lambda_name}-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
