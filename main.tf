# main.tf

module "key_vault" {
  source         = "./modules/pull_key_vault"
  key_vault_name = var.key_vault_name
  key_vault_rg   = var.key_vault_rg
}

module "resource_group" {
  source   = "./modules/create_resource_group"
  name     = var.new_resource_group_name
  location = var.location
}

module "virtual_network" {
  source              = "./modules/create_virtual_network"
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = var.location
  resource_group_name = module.resource_group.name
  subnets             = var.subnets
}

module "network_security_group" {
  source              = "./modules/create_nsg"
  nsg_name            = var.nsg_name
  location            = var.location
  resource_group_name = module.resource_group.name
  security_rules      = var.security_rules
  subnet_ids          = module.virtual_network.subnet_ids
}



module "vm" {
  source              = "./modules/create_vm"
  resource_group_name = module.resource_group.name
  location            = var.location
  subnet_id           = module.virtual_network.subnet_ids[0]
  admin_username      = module.key_vault.admin_username
  admin_password      = module.key_vault.admin_password
  vm_configs          = var.vm_configs
}
