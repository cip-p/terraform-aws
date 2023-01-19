locals {
  name_prefix = "${var.application}-${var.env}"
  tags = {
    Environment = var.env
    Terraform   = true
    infra-unit  = "app-runner-cakes-api"
  }
}

resource "aws_apprunner_service" "this" {
  service_name                   = "${local.name_prefix}-cakes-api"
  auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration_version.this.arn

  source_configuration {
    authentication_configuration {
      access_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/service-role/AppRunnerECRAccessRole"
    }
    image_repository {
      image_configuration {
        port = var.docker_container_port
      }
      image_identifier      = var.initial_image_identifier
      image_repository_type = var.image_repository_type
    }
    auto_deployments_enabled = var.auto_deployments_enabled
  }

  instance_configuration {
    instance_role_arn = aws_iam_role.instance_role.arn
  }

  lifecycle {
    prevent_destroy = true

    ignore_changes = [
      # changed by deployment
      source_configuration[0].image_repository[0].image_identifier,
      source_configuration[0].image_repository[0].image_configuration[0].runtime_environment_variables
    ]
  }

  tags = local.tags
}

resource "aws_apprunner_auto_scaling_configuration_version" "this" {
  auto_scaling_configuration_name = "${local.name_prefix}-asg-cakes-api"
  max_concurrency                 = var.cakes_api_max_concurrency
  max_size                        = var.cakes_api_max_size
  min_size                        = var.cakes_api_min_size

  tags = local.tags
}

data "template_file" "instance_role_template" {
  template = file("${path.module}/templates/app-runner-instance-role.tpl")
}

resource "aws_iam_role" "instance_role" {
  name = "${local.name_prefix}-app-runner-instance-role"

  assume_role_policy = data.template_file.instance_role_template.rendered
}

data "template_file" "instance_policy_template" {
  template = file("${path.module}/templates/app-runner-instance-policy.tpl")
}

resource "aws_iam_role_policy" "instance_role_policy" {
  name = "${local.name_prefix}-app-runner-instance-policy"
  role = aws_iam_role.instance_role.id

  policy = data.template_file.instance_policy_template.rendered
}
