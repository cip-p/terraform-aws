variable "application" {
  description = "Application name; e.g. cakes-service"
}

variable "env" {
  description = "Environment name; e.g. dev, prod"
}

variable "region" {
  description = "AWS region"
}

variable "initial_image_identifier" {
  default     = "<aws_account>.dkr.ecr.us-east-1.amazonaws.com/cakes-api:<application_version>"
  description = "The ECR url containing a version of the app. This will be overridden by future deployments."
}

variable "image_repository_type" {
  default     = "ECR"
  description = "The ECR repository type. It's 'ECR' using AWS IAM role authentication."
}

variable "auto_deployments_enabled" {
  default     = false
  description = "The auto deployment can't be true for ECR sources."
}

variable "docker_container_port" {
  default     = 8080
  description = "The port the app is listening in the docker container."
}

variable "cakes_api_max_concurrency" {
  description = "The maximal number of concurrent requests that you want an instance to process. When the number of concurrent requests goes over this limit, App Runner scales up your service."
}

variable "cakes_api_max_size" {
  description = "The maximal number of instances that App Runner provisions for your service."
}

variable "cakes_api_min_size" {
  description = "The minimal number of instances that App Runner provisions for your service."
}

