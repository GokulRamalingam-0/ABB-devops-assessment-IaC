
resource "azurerm_storage_account" "state" {
  name                     = var.storage_account_name
  resource_group_name      = var.backend_rg_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  #allow_blob_public_access = false

  blob_properties {
    versioning_enabled = true
  }
}

resource "azurerm_storage_container" "state" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.state.name
  container_access_type = "private"
}

output "storage_account_name" { value = azurerm_storage_account.state.name }
output "container_name"       { value = azurerm_storage_container.state.name }
