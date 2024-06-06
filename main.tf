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
  bastion_subnet      = var.bastion_subnet
}

module "network_security_group" {
  source              = "./modules/create_nsg"
  nsg_name            = var.nsg_name
  location            = var.location
  resource_group_name = module.resource_group.name
  security_rules      = var.security_rules
  subnet_ids          = module.virtual_network.subnet_ids
}

module "nat_gateway" {
  source              = "./modules/create_nat_gateway"
  location            = var.location
  resource_group_name = module.resource_group.name
  subnet_id           = module.virtual_network.subnet_ids[0]
  prefix_length       = 30 # or any other length you prefer
}

module "bastion_host" {
  source              = "./modules/create_bastion_host"
  bastion_name        = var.bastion_name
  location            = var.location
  resource_group_name = module.resource_group.name
  subnet_id           = module.virtual_network.bastion_subnet_id

  # Add dependency to ensure the virtual network and subnet are created first
  depends_on = [
    module.virtual_network
  ]

}

module "vm" {
  source              = "./modules/create_vm"
  resource_group_name = module.resource_group.name
  location            = var.location
  subnet_id           = module.virtual_network.subnet_ids[0]
  admin_username      = module.key_vault.admin_username
  admin_password      = module.key_vault.admin_password
  vm_configs          = var.vm_configs

  # Add dependency to ensure the virtual network and nat gateway are created first
  depends_on = [
    module.virtual_network,
    module.nat_gateway
  ]

}

