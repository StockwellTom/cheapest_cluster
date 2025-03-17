resource "azuread_application" "crossplane-app" {
  display_name = "crossplane"
}

resource "azuread_service_principal" "crossplane-sp" {
  application_id = azuread_application.crossplane-app.application_id
}

resource "random_password" "crossplane-sp-password" {
  length  = 16
  special = true
}

resource "azuread_service_principal_password" "crossplane-sp-password-assign" {
  service_principal_id = azuread_service_principal.crossplane-sp.id
  value                = random_password.crossplane-sp-password.result
  end_date             = "2099-01-01T00:00:00Z"
}

resource "azurerm_role_assignment" "crossplane-ra" {
  principal_id   = azuread_service_principal.crossplane-sp.id
  role_definition_name = "Owner"
  scope          = "/subscriptions/b133cf1b-9061-473a-a041-99c71f10c773"
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_key_vault" "crossplane-kv" {
  name                = "kv-crossplane-${random_string.suffix.result}"
  location            = azurerm_resource_group.main_cluster.location
  resource_group_name = azurerm_resource_group.main_cluster.name

  tenant_id = "9c3053bb-1522-475e-82b2-b426b68a8004"

  sku_name = "standard"

  access_policy {
    tenant_id = "9c3053bb-1522-475e-82b2-b426b68a8004"
    object_id = "1a45d9e9-6f0d-44f0-8154-233711b1ad2f" # Replace with your Azure AD object ID

    secret_permissions = [
      "get",
      "list",
    ]
  }
}

resource "azurerm_key_vault_secret" "example" {
  name         = "crossplane-password"
  value        = random_password.crossplane-sp-password.result
  key_vault_id = azurerm_key_vault.crossplane-kv.id
}