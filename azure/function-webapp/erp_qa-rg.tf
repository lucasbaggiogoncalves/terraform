resource "azurerm_resource_group" "erp_qa-dev-webapp-us2" {
  provider = azurerm.erp-dev
  count    = var.count.dev.dev-webapp.value
  name     = "${var.environment.development.value}${var.project_name.webapp.value}${index(count.index)}${var.resource_type.resourcegroup.value}"
  location = var.location.primary.value
}