resource "azurerm_user_assigned_identity" "cluster_mi" {
  location            = azurerm_resource_group.main_cluster.location
  name                = "cluster_contributor"
  resource_group_name = azurerm_resource_group.main_cluster.name
}

resource "azurerm_role_assignment" "aks_sp_role_assignment" {
  scope                = azurerm_kubernetes_cluster.aks_cluster.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.cluster_mi.principal_id
}