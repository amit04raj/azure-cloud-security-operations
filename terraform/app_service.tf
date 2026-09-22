resource "azurerm_service_plan" "app" {
  name                = "asp-cloud-security-operations"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name            = "B1"

  tags = {
    project     = "azure-cloud-security-operations"
    environment = "portfolio"
    managed_by  = "terraform"
  }
}

resource "azurerm_linux_web_app" "app" {
  name                = "app-cloud-security-operations"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  service_plan_id     = azurerm_service_plan.app.id

  https_only = true

  ftp_publish_basic_authentication_enabled       = false
  webdeploy_publish_basic_authentication_enabled = false

  site_config {
    minimum_tls_version = "1.2"

    application_stack {
      python_version = "3.12"
    }

    app_command_line = "python -m uvicorn app.main:app --host 0.0.0.0 --port 8000"
  }

  app_settings = {
    SCM_DO_BUILD_DURING_DEPLOYMENT        = "true"
    APPLICATIONINSIGHTS_CONNECTION_STRING = azurerm_application_insights.main.connection_string
  }

  tags = {
    project     = "azure-cloud-security-operations"
    environment = "portfolio"
    managed_by  = "terraform"
  }

  lifecycle {
   ignore_changes = [
      tags["hidden-link: /app-insights-resource-id"]
    ]
  }
}