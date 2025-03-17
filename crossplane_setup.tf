resource "azurerm_user_assigned_identity" "crossplane_mi" {
  location            = azurerm_resource_group.main_cluster.location
  name                = "crossplane_sub_owner"
  resource_group_name = azurerm_resource_group.main_cluster.name
}

resource "azurerm_role_assignment" "crossplane_mi_owner" {
  scope                = "/subscriptions/b133cf1b-9061-473a-a041-99c71f10c773"
  role_definition_name = "Owner"
  principal_id         = azurerm_user_assigned_identity.crossplane_mi.principal_id
}