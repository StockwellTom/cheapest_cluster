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

resource "azurerm_federated_identity_credential" "turn-off-cluster-federated-credential" {
  name                = "fc-turn-off-cluster"
  resource_group_name = "main_cluster"
  audience            = ["api://AzureADTokenExchange"]
  issuer              = "https://westeurope.oic.prod-aks.azure.com/9c3053bb-1522-475e-82b2-b426b68a8004/61cd0ea9-54c9-4949-875f-530f3013b097/"
  parent_id           = azurerm_user_assigned_identity.cluster_mi.id
  subject             = "system:serviceaccount:turn-off-cluster:turn-off-cluster-mi"
}