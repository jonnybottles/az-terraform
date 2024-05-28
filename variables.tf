# variables.tf

variable "key_vault_name" {
  description = "The name of the existing Key Vault"
  type        = string
}

variable "key_vault_rg" {
  description = "The name of the resource group containing the Key Vault"
  type        = string
}
