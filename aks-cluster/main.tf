resource "random_pet" "prefix" {}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${random_pet.prefix.id}-aks"
  location            = var.location
  resource_group_name = var.rg_name
  dns_prefix          = "${random_pet.prefix.id}-k8s"
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name            = "default"
    node_count      = 2
    vm_size         = "Standard_D2s_v3"
    os_disk_size_gb = 30
  }

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control_enabled = true

  oms_agent {
  log_analytics_workspace_id      = var.log_analytics_workspace_id
  msi_auth_for_monitoring_enabled = true
  }

  tags = {
    environment = "Demo"
  }
}

resource "azurerm_monitor_diagnostic_setting" "control_plane" {
  name                       = "aks-controlplane"
  target_resource_id         = azurerm_kubernetes_cluster.aks.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log { category = "kube-apiserver"          }
  enabled_log { category = "kube-controller-manager" }
  enabled_log { category = "kube-scheduler"          }
  enabled_log { category = "cluster-autoscaler"      }
  enabled_log { category = "kube-audit"              }

  metric { category = "AllMetrics" }
}

output "cluster_name" { value = azurerm_kubernetes_cluster.aks.name }
output "cluster_id"   { value = azurerm_kubernetes_cluster.aks.id   }
