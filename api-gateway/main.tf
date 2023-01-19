locals {
  name_prefix = "${var.application}-${var.env}"
  tags = {
    Environment = var.env
    Terraform   = true
    infra-unit  = "api-gateway-cakes-api"
  }
}

resource "aws_api_gateway_rest_api" "this" {
  name        = "${local.name_prefix}-cakes-api-gateway"
  description = "Cakes API - API Gateway"

  endpoint_configuration {
    types = ["EDGE"]
  }

  tags = local.tags
}

resource "aws_api_gateway_authorizer" "this" {
  name                             = "${var.application}-ApiGatewayAuthorizer"
  type                             = "TOKEN"
  rest_api_id                      = aws_api_gateway_rest_api.this.id
  identity_source                  = "method.request.header.Authorization"
  authorizer_uri                   = data.aws_lambda_function.authorizer.invoke_arn
  authorizer_result_ttl_in_seconds = 0
}

resource "aws_lambda_permission" "allow_api_gateway" {
  function_name = data.aws_lambda_function.authorizer.function_name
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.this.execution_arn}/*/*/*"
}

resource "aws_lambda_permission" "allow_api_gateway_authorizer" {
  function_name = data.aws_lambda_function.authorizer.function_name
  statement_id  = "AllowExecutionFromApiGatewayAuthorizer"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.this.execution_arn}/authorizers/${aws_api_gateway_authorizer.this.id}"
}

resource "aws_cloudwatch_log_group" "access_log_group" {
  name              = "/aws/api-gateway/${aws_api_gateway_rest_api.this.id}/${var.api_gw_stage_name}/access-log"
  retention_in_days = var.api_gw_log_retention
}

resource "aws_api_gateway_stage" "this" {
  deployment_id         = aws_api_gateway_deployment.healthcheck_initial.id
  rest_api_id           = aws_api_gateway_rest_api.this.id
  stage_name            = var.api_gw_stage_name
  cache_cluster_enabled = false

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.access_log_group.arn
    format          = file("${path.module}/templates/log_format.json")
  }

  lifecycle {
    ignore_changes = [
      # gets updated by the API deployment
      deployment_id,
      cache_cluster_size
    ]
  }
}

resource "aws_api_gateway_method_settings" "all" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = aws_api_gateway_stage.this.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
    #    for full request/response body logging
    data_trace_enabled = var.cakes_api_gw_log_full_request_response_body
  }
}

// list of response types
// https://docs.aws.amazon.com/apigateway/latest/developerguide/supported-gateway-response-types.html
resource "aws_api_gateway_gateway_response" "this" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  status_code   = "403"
  response_type = "ACCESS_DENIED"

  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Origin" = "'*'"
  }

  lifecycle {
    ignore_changes = [
      response_templates
    ]
  }
}


### Initial dummy integration ###
# deployment will be overridden by the openapi publishing

resource "aws_api_gateway_deployment" "healthcheck_initial" {
  depends_on = [aws_api_gateway_integration.healthcheck_integration]

  rest_api_id = aws_api_gateway_rest_api.this.id

  stage_name = ""
}

resource "aws_api_gateway_resource" "healthcheck" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "health"
}

resource "aws_api_gateway_method" "healthcheck_get" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.healthcheck.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "healthcheck_integration" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.healthcheck.id
  http_method = aws_api_gateway_method.healthcheck_get.http_method

  type = "MOCK"

  request_templates = {
    "application/json" = <<EOF
{
  "statusCode": 200
}
EOF
  }

  depends_on = [aws_api_gateway_rest_api.this]
}

resource "aws_api_gateway_integration_response" "healthcheck_integration" {
  depends_on = [aws_api_gateway_integration.healthcheck_integration]

  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.healthcheck.id
  http_method = aws_api_gateway_method.healthcheck_get.http_method
  status_code = 200
}

resource "aws_api_gateway_method_response" "healthcheck_200" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.healthcheck.id
  http_method = aws_api_gateway_method.healthcheck_get.http_method
  status_code = "200"
}
