
# modules/pull_key_vault/main.tf

data "azurerm_key_vault" "kv" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_rg
}

data "azurerm_key_vault_secret" "admin_username" {
  name         = "vmAdminUsername1"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "admin_password" {
  name         = "vmAdminPassword1"
  key_vault_id = data.azurerm_key_vault.kv.id
}

#data "azurerm_key_vault_secret" "vpn_shared_key" {
#  name         = "vpn-shared-key"  
#  key_vault_id = data.azurerm_key_vault.kv.id
#}

#data "azurerm_key_vault_secret" "storage_account_key" {
#  name         = "storage-account-key"
#  key_vault_id = data.azurerm_key_vault.kv.id
#}