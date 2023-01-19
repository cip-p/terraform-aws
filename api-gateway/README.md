# Terraform AWS - API Gateway resource

## Features

- REST API
- lambda authorizer
- cloudwatch logging
- request / response logging
- DNS record
- ACM certificate creation and validation


### It depends on infra units
- [DNS (Route53 Zone)](../dns)
- [Lambda API Gateway Authorizer](../lambda-api-gw-authorizer)

- - - -

Terraform AWS API Gateway resource: [aws_api_gateway_rest_api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api)
