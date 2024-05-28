# pull_key_vault/outputs.tf

output "client_id_retrieved" {
  description = "Confirmation that the Client ID was successfully retrieved from Key Vault"
  value       = "Azure Service Principal Client ID successfully retrieved."
}

output "client_secret_retrieved" {
  description = "Confirmation that the Client Secret was successfully retrieved from Key Vault"
  value       = "Azure Service Principal Client Secret successfully retrieved."
}

output "tenant_id_retrieved" {
  description = "Confirmation that the Tenant ID was successfully retrieved from Key Vault"
  value       = "Azure Service Principal Tenant ID successfully retrieved."
}

