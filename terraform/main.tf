resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    project     = "azure-cloud-security-operations"
    environment = "portfolio"
    managed_by  = "terraform"
  }
}