data "azurerm_user_assigned_identity" "kubelet_id" {
  name                = "my-aks-cluster-agentpool" # maybe try not hard code
  resource_group_name = azurerm_kubernetes_cluster.aks_cluster.node_resource_group
}

resource "azurerm_role_assignment" "crossplane_mi_owner" {
  scope                = "/subscriptions/b133cf1b-9061-473a-a041-99c71f10c773"
  role_definition_name = "Owner"
  principal_id         = data.azurerm_user_assigned_identity.kubelet_id.principal_id
}