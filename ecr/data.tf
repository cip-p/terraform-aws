data "aws_caller_identity" "current" {}

data "template_file" "ecr_repo_policy" {
  template = file("${path.module}/templates/ecr_repo_policy.json.tpl")

  vars = {
    account    = data.aws_caller_identity.current.account_id
    account_id = var.ecr_account_id
  }
}

data "template_file" "lifecycle_policy" {
  template = file("${path.module}/templates/lifecycle_policy.json.tpl")

  vars = {
    images_limit = var.images_limit
  }
}
