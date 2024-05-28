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

# Obtain existing Resource Group
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

# Create virtual network
resource "azurerm_virtual_network" "main" {
  name                = "mainVNet"
  address_space       = var.main_vnet_address_space
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

# Create Subnets within the VNet
resource "azurerm_subnet" "subnet1" {
  name                 = "subnet1"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.subnet1_prefix
}

