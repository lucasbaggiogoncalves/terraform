terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.86.0"
    }
  }
}

provider "azurerm" {
  alias           = "erp-dev"
  subscription_id = var.subscription_id.erp-qa.value
  tenant_id       = var.tenant_id
  features {}
}

