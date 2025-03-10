resource "azurerm_key_vault" "vm_password_kv" {
  name                        = format("vm-creds-kv-%s", random_string.kv_suffix.result)
  location                    = azurerm_resource_group.main_cluster.location
  resource_group_name         = azurerm_resource_group.main_cluster.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}

resource "random_password" "vm_password" {
  length  = 16
  special = true
}

resource "random_string" "kv_suffix" {
  length           = 8
  special          = false
}

resource "azurerm_key_vault_secret" "vm_password_secret" {
  name         = "vmAdminPassword"
  value        = random_password.vm_password.result
  key_vault_id = azurerm_key_vault.vm_password_kv.id
}