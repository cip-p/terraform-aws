locals {
  name_prefix = "${var.application}-${var.env}"
  tags = {
    Environment = var.env
    Terraform   = true
    infra-unit  = "cakes-slack-alerts"
  }
}

resource "aws_sns_topic" "cloudwatch_alarms" {
  name = "${local.name_prefix}-cloudwatch-alarms"

  tags = local.tags
}

resource "aws_lambda_function" "send_cloudwatch_alarms_to_slack" {
  function_name    = "${local.name_prefix}-send-cloudwatch-alarms-to-slack"
  filename         = data.archive_file.lambda.output_path
  role             = aws_iam_role.send_cloudwatch_alarms_to_slack.arn
  handler          = "send_slack_message_lambda.handler"
  source_code_hash = filebase64sha256(data.archive_file.lambda.output_path)
  runtime          = "python3.9"

  environment {
    variables = {
      dummy = "terraform-environment-variable-used-for-initialisation-only"
    }
  }

  lifecycle {
    ignore_changes = [
      # manually set in the AWS console
      environment.0.variables
    ]
  }

  tags = local.tags
}

resource "aws_lambda_permission" "sns_alarms" {
  statement_id  = "AllowExecutionFromSNSAlarms"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.send_cloudwatch_alarms_to_slack.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.cloudwatch_alarms.arn
}

resource "aws_sns_topic_subscription" "alarms" {
  topic_arn = aws_sns_topic.cloudwatch_alarms.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.send_cloudwatch_alarms_to_slack.arn
}

resource "aws_iam_role" "send_cloudwatch_alarms_to_slack" {
  name = "${local.name_prefix}-send-cloudwatch-alarms-to-slack"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "${path.module}/lambda"
  output_path = "lambda.zip"
}
