terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.33.0"
    }
  }
}

provider "aws" {
  region = var.availability_zone

  access_key = "secret-value"
  secret_key = "secret-value"
}