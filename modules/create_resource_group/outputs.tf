# outputs.tf
output "resource_group_name" {
  description = "The name of the new resource group"
  value       = azurerm_resource_group.example.name
}
