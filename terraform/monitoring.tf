resource "azurerm_log_analytics_workspace" "main" {
  name                = "law-cloud-security-operations"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    project     = "azure-cloud-security-operations"
    environment = "portfolio"
    managed_by  = "terraform"
  }
}

resource "azurerm_application_insights" "main" {
  name                = "appi-cloud-security-operations"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.main.id
  retention_in_days   = 30

  tags = {
    project     = "azure-cloud-security-operations"
    environment = "portfolio"
    managed_by  = "terraform"
  }
}