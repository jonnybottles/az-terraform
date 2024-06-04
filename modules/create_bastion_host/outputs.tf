# modules/create_bastion_host/outputs.tf

output "bastion_id" {
  description = "ID of the Bastion Host"
  value       = azurerm_bastion_host.bastion.id
}

output "bastion_public_ip" {
  description = "Public IP of the Bastion Host"
  value       = azurerm_public_ip.bastion_public_ip.ip_address
}

