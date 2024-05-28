# outputs.tf

output "existing_resource_group_name" {
  description = "The name of the existing resource group the VNet is associated with"
  value       = data.azurerm_resource_group.rg.name
}

output "main_vnet_name" {
  description = "The name of the new main Virtual Network"
  value       = azurerm_virtual_network.main.name
}

output "subnet1_name" {
  description = "The name of the first subnet in the main VNet"
  value       = azurerm_subnet.subnet1.name
}