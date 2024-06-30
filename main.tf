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
  prefix_length       = 30 # or any other length 
}

#module "bastion_host" {
#  source              = "./modules/create_bastion_host"
#  bastion_name        = var.bastion_name
#  location            = var.location
#  resource_group_name = module.resource_group.name
#  subnet_id           = module.virtual_network.bastion_subnet_id
#  depends_on          = [module.virtual_network]
#}

module "vm" {
  source              = "./modules/create_vm"
  resource_group_name = module.resource_group.name
  location            = var.location
  subnet_id           = module.virtual_network.subnet_ids[0]
  admin_username      = module.key_vault.admin_username
  admin_password      = module.key_vault.admin_password
  vm_configs          = var.vm_configs
  depends_on          = [module.virtual_network, module.nat_gateway]
}

module "enable_winrm_over_https" {
  source         = "./modules/enable_winrm_over_https"
  admin_username = module.key_vault.admin_username
  admin_password = module.key_vault.admin_password
  vm_configs     = var.vm_configs
  vm_ids         = module.vm.vm_ids
  vm_private_ips = module.vm.vm_private_ips
  vm_public_ips  = module.vm.vm_public_ips
}


module "generate_inventory" {
  source = "./modules/create_ansible_inventory"
  vm_infos = zipmap(module.vm.vm_names, [
    for i in range(length(module.vm.vm_names)) : {
      ip    = var.use_public_ip ? module.vm.vm_public_ips[i] : module.vm.vm_private_ips[i]
      is_dc = module.vm.vm_is_dc[i]
    }
  ])
  ansible_user        = module.key_vault.admin_username
  ansible_password    = module.key_vault.admin_password
  inventory_file_path = var.inventory_file_path
  depends_on          = [module.vm]
}

output "inventory_file_path" {
  value = module.generate_inventory.inventory_file_path
}


#module "create_ansible_control_node" {
#  source                 = "./modules/create_ansible_control_node"
#  ssh_key_path           = var.ssh_key_path
#  resource_group_name    = module.resource_group.name
#  location               = var.location
#  subnet_id              = module.virtual_network.subnet_ids[1]  # Use the containers-subnet for the container group
#  network_security_group = module.network_security_group.nsg_id
#  container_subnet_id    = module.virtual_network.subnet_ids[1]  # Use the containers-subnet for the container group
#  vm_subnet_id           = module.virtual_network.subnet_ids[0]  # Use the vm-subnet for the control node NIC
#}

