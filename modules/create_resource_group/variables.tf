#variables.tf

variable "subscription_id" {
  description = "The Subscription ID for Azure"
  type        = string
}

variable "key_vault_rg" {
  description = "The name of the resource group containing the Key Vault"
  type        = string
}

variable "location" {
  description = "The Azure region to deploy resources"
  type        = string
}

variable "key_vault_name" {
  description = "The name of the existing Key Vault"
  type        = string
}

variable "new_resource_group_name" {
  description = "The name of the new resource group to create"
  type        = string
}
