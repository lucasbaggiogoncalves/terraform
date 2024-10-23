variable "tenant_id" {
  type    = string
  default = "tenantid"
}

variable "subscription_id" {
  type = map(string)
  default = {
    "erp-qa" = "subid"
  }
}

variable "region" {
  type = map(string)
  default = {
    "primary"     = "eastus2"
    "secondary"   = "northcentralus"
    "contingency" = "brazilsouth"
  }
}

variable "environment" {
  type = map(string)
  default = {
    "development" = "dev"
  }
}

variable "resource_type" {
  type = map(string)
  default = {
    "functionapp"    = "fapp"
    "resourcegroup"  = "rg"
    "appserviceplan" = "ASP-"
  }
}

variable "project_name" {
  type = map(string)
  default = {
    "webapp" = "webapp"
  }
}

variable "count_dev" {
  type = map(number)
  default = {
    "dev-webapp" = 2
  }
}
