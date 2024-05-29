#create_vm/outputs.tf

output "vm_ids" {
  description = "The IDs of the created VMs"
  value       = azurerm_windows_virtual_machine.vm[*].id
}

output "vm_names" {
  description = "The names of the created VMs"
  value       = azurerm_windows_virtual_machine.vm[*].name
}
