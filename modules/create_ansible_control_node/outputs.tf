# /modules/create_ansible_control_node/outputs.tf

output "container_id" {
  description = "The ID of the container instance"
  value       = azurerm_container_group.control_node.id
}

output "container_ip" {
  description = "The IP address of the container instance"
  value       = azurerm_container_group.control_node.ip_address
}
