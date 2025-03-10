provider "azurerm" {
  features {}
  subscription_id= "b133cf1b-9061-473a-a041-99c71f10c773"
  resource_provider_registrations = "none"
}

resource "azurerm_resource_group" "main_cluster" {
  name     = "main_cluster"
  location = "West Europe"
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "my-aks-cluster"
  location            = azurerm_resource_group.main_cluster.location
  resource_group_name = azurerm_resource_group.main_cluster.name
  dns_prefix          = "myakscluster"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"  # Cheapest node size
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "basic"  # Basic SKU load balancer
  }
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
  sensitive = true
}