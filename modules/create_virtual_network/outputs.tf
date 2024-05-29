# create virtual network outputs.tf

output "vnet_name" {
  description = "The name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "subnet_names" {
  description = "The names of the subnets"
  value       = [for subnet in azurerm_subnet.subnet : subnet.name]
}

output "subnet_ids" {
  description = "The IDs of the created subnets"
  value       = azurerm_subnet.subnet[*].id
}

