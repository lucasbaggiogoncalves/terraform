resource "azurerm_storage_account" "erp_qa-dev-webapp-us2" {
  provider                 = azurerm.erp-dev
  count                    = var.count.dev.dev-webapp.value
  name                     = "${var.environment.development.value}${var.project_name.webapp.value}${index(count.index)}544566"
  resource_group_name      = azurerm_resource_group.erp_qa-dev-webapp-us2.name
  location                 = var.location.primary.value
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "erp_qa-dev-webapp-us2" {
  provider            = azurerm.erp-dev
  count               = var.count.dev.dev-webapp.value
  name                = "${var.resource_type.appserviceplan.value}${var.environment.development.value}${var.project_name.webapp.value}${index(count.index)}"
  resource_group_name = azurerm_resource_group.erp_qa-dev-webapp-us2.name
  location            = var.location.primary.value
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "erp_qa-dev-webapp-us2" {
  provider            = azurerm.erp-dev
  count               = var.count.dev.dev-webapp.value
  name                = "${var.environment.development.value}${var.resource_type.functionapp.value}${var.project_name.webapp.value}${index(count.index)}"
  resource_group_name = azurerm_resource_group.erp_qa-dev-webapp-us2.name
  location            = var.location.primary.value

  storage_account_name       = azurerm_storage_account.erp_qa-dev-webapp-us2.name
  storage_account_access_key = azurerm_storage_account.erp_qa-dev-webapp-us2.primary_access_key
  service_plan_id            = azurerm_service_plan.erp_qa-dev-webapp-us2.id

  site_config {}
}