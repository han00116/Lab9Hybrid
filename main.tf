provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "app" {
  name     = "hanresourceaks"
  location = "West US 3"
}

resource "azurerm_kubernetes_cluster" "app" {
  name                = "hancluster"
  location            = azurerm_resource_group.app.location
  resource_group_name = azurerm_resource_group.app.name
  dns_prefix          = "aks-cluster-dns"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
    enable_auto_scaling = true
    min_count = 1
    max_count = 3
  }


  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
  }

  depends_on = [azurerm_resource_group.app]
}
output "kube_config" {
  value = azurerm_kubernetes_cluster.app.kube_config_raw

  sensitive = true
}