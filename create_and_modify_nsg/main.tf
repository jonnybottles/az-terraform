# main.tf
data "azurerm_key_vault" "kv" {
  provider            = azurerm.keyvault
  name                = var.key_vault_name
  resource_group_name = var.key_vault_rg
}

data "azurerm_key_vault_secret" "client_id" {
  provider     = azurerm.keyvault
  name         = "servicePrincipalClientId"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "client_secret" {
  provider     = azurerm.keyvault
  name         = "servicePrincipalClientSecret"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "tenant_id" {
  provider     = azurerm.keyvault
  name         = "servicePrincipalTenantId"
  key_vault_id = data.azurerm_key_vault.kv.id
}

provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = data.azurerm_key_vault_secret.client_id.value
  client_secret   = data.azurerm_key_vault_secret.client_secret.value
  tenant_id       = data.azurerm_key_vault_secret.tenant_id.value
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = var.new_resource_group_name
  location = var.location
}
