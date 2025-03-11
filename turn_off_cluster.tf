resource "azuread_application" "turn_off_cluster_app" {
  display_name = "turn_off_cluster_app"
}

resource "azuread_service_principal" "turn_off_cluster_sp" {
  application_id = azuread_application.turn_off_cluster_app.application_id
}