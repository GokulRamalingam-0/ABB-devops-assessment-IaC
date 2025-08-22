terraform {
  required_version = ">= 1.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
    random = { source = "hashicorp/random" }
  }


  backend "azurerm" {
    resource_group_name  = "kml_rg_main-167d6474acbb46c7"
    storage_account_name = "tfstate41601"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    use_azuread_auth     = true
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

module "monitoring" {
  source         = "./monitor"
  rg_name        = var.rg_name
  location       = var.location
  workspace_name = "${var.prefix}-law"
  retention_days = 30
}

module "aks_cluster" {
  source                     = "./aks-cluster"
  prefix                     = var.prefix
  rg_name                    = var.rg_name
  location                   = var.location
  kubernetes_version         = var.kubernetes_version
  log_analytics_workspace_id = module.monitoring.workspace_id
}

module "key_vault" {
  source         = "./key_vault"
  rg_name        = var.rg_name
  location       = var.location
  key_vault_name = "docker-key-vault412"
}

module "linux_vm" {
  source   = "./azure_vm"
  rg_name  = var.rg_name
  location = var.location
}

module "contiainer_registry" {
  source   = "./azure_container_registry"
  rg_name  = var.rg_name
  location = var.location
}