resource "azurerm_container_registry" "acr" {
  name                              = "assessment"
  resource_group_name               = var.rg_name
  location                          = var.location
  sku                               = "Standard"
  admin_enabled                     = true
  public_network_access_enabled     = true
}