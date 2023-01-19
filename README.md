# Terraform AWS provider

## Creating AWS resources using terraform [AWS provider](https://registry.terraform.io/providers/hashicorp/aws/latest)

## List of resources

- [API Gateway](api-gateway)
- [API Gateway Account](api-gateway-account)
- [App Runner](app-runner)
- [Cognito](cognito)
- [DNS (Route53 Zone)](dns)
- [Elastic Container Registry (ECR)](ecr)
- [Lambda API Gateway Authorizer](lambda-api-gw-authorizer)
- [S3 bucket](s3-bucket)
- [Simple Email Service (SES)](ses)
- [Slack alerts - Cloudwatch, SNS](cloudwatch-slack-alerts)

- - - -

Example of variable values used in terraform infra units: [terraform-example.tfvars](terraform-example.tfvars)

- - - -

Minimal build pipeline checking formatting and validating terraform code: [GA](.github/workflows); see `Actions` tab.
