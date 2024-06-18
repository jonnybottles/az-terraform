#create_vm/outputs.tf

output "vm_ids" {
  description = "The IDs of the created VMs"
  value       = azurerm_windows_virtual_machine.vm[*].id
}

output "vm_names" {
  description = "The names of the created VMs"
  value       = azurerm_windows_virtual_machine.vm[*].name
}

output "vm_private_ips" {
  description = "The private IP addresses of the NICs attached to the VMs"
  value       = azurerm_network_interface.nic[*].private_ip_address
}

output "vm_public_ips" {
  description = "The public IP addresses of the VMs"
  value       = [for ip in azurerm_public_ip.public_ip[*] : ip.ip_address]
}

output "vm_is_dc" {
  description = "Indicates whether each VM is a Domain Controller"
  value       = [for config in var.vm_configs : config.is_dc]
}