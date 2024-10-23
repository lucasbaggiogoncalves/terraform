# Terraform Cloud

terraform {
  cloud {
    organization = "organization"
    workspaces {
      name = "prd"
    }
  }
}

# Provider

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.70.0"
    }
  }
}

# Locals

locals {
  resource-prefix = "${var.environment}-${var.region}"
}