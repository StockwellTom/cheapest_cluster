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
    name                 = "default"
    node_count           = 1
    vm_size              = "Standard_B2s" # Cheapest node size
    auto_scaling_enabled = false
  }

  upgrade_settings {
    drain_timeout_in_minutes      = 0
    max_surge                     = "10%"
    node_soak_duration_in_minutes = 0
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "basic" # Basic SKU load balancer
  }
}