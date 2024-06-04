# pull_key_vault/outputs.tf

output "admin_username" {
  description = "The admin username retrieved from Key Vault"
  value       = data.azurerm_key_vault_secret.admin_username.value
  sensitive   = true
}

output "admin_password" {
  description = "The admin password retrieved from Key Vault"
  value       = data.azurerm_key_vault_secret.admin_password.value
  sensitive   = true
}

output "vpn_shared_key" {
  description = "The VPN shared key retrieved from Key Vault"
  value       = data.azurerm_key_vault_secret.vpn_shared_key.value
  sensitive   = true
}
