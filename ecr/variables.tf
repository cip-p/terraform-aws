variable "application" {
  description = "Application name; e.g. cakes-service"
}

variable "env" {
  description = "Environment name; e.g. dev, prod"
}

variable "region" {
  description = "AWS region"
}

variable "ecr_services" {
  description = "List of services requiring ECR repository"
  default     = []
  type        = list(any)
}

variable "ecr_account_id" {
  description = "The ID of the AWS account"
}

variable "images_limit" {
  description = "The number of last tagged or untagged images stored"
  type        = string
  default     = "100"
}
