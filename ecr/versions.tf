terraform {
  required_version = ">= 1.3.7"
}

provider "aws" {
  region = var.region
}
