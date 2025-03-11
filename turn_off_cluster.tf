data "azuread_client_config" "current" {}

resource "azuread_application" "cluster_app" {
  display_name = "turn_off_cluster_app"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "cluster_app_sp" {
  client_id                    = azuread_application.cluster_app.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}