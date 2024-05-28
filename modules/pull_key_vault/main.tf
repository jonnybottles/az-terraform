
# modules/pull_key_vault/main.tf

data "azurerm_key_vault" "kv" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_rg
}

data "azurerm_key_vault_secret" "client_id" {
  name         = "servicePrincipalClientId"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "client_secret" {
  name         = "servicePrincipalClientSecret"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "tenant_id" {
  name         = "servicePrincipalTenantId"
  key_vault_id = data.azurerm_key_vault.kv.id
}
