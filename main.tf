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
    resource_group_name  = "kml_rg_main-e1a2d089e4544aa9"
    storage_account_name = "tfstate41603"
    container_name       = "tfstate"
    key                  = "aks/production.tfstate"
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

module "state" {
  source               = "./storage-account"
  backend_rg_name      = "kml_rg_main-e1a2d089e4544aa9"
  location             = var.location
  storage_account_name = "tfstate41603"
  container_name       = "tfstate"
}

module "monitoring" {
  source         = "./monitor"
  rg_name        = var.cluster_rg_name
  location       = var.location
  workspace_name = "${var.prefix}-law"
  retention_days = 30
}

module "aks_cluster" {
  source             = "./aks-cluster"
  prefix             = var.prefix
  rg_name            = var.cluster_rg_name
  location           = var.location
  kubernetes_version = var.kubernetes_version

  log_analytics_workspace_id = module.monitoring.workspace_id
}