locals {
  name_prefix = "${var.application}-${var.env}"
  tags = {
    Environment = var.env
    Terraform   = true
    infra-unit  = "ecr"
  }
}

resource "aws_ecr_repository" "this" {
  count                = length(var.ecr_services)
  name                 = var.ecr_services[count.index]
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = local.tags

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_ecr_repository_policy" "ecr_repo_policy" {
  count      = length(var.ecr_services)
  repository = aws_ecr_repository.this.*.name[count.index]
  policy     = data.template_file.ecr_repo_policy.rendered
}

resource "aws_ecr_lifecycle_policy" "lifecycle_policy" {
  count      = length(var.ecr_services)
  repository = aws_ecr_repository.this.*.name[count.index]
  policy     = data.template_file.lifecycle_policy.rendered
}
