# /modules/create_ansible_control_node/outputs.tf

output "container_id" {
  description = "The ID of the container instance"
  value       = azurerm_container_group.control_node.id
}

output "container_ip" {
  description = "The IP address of the container instance"
  value       = azurerm_container_group.control_node.ip_address
}

output "control_node_nic_id" {
  description = "The ID of the network interface for the control node"
  value       = azurerm_network_interface.control_node_nic.id
}

output "control_node_nic_ip" {
  description = "The IP address of the network interface for the control node"
  value       = azurerm_network_interface.control_node_nic.ip_configuration[0].private_ip_address
}
