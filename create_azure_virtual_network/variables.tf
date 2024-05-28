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

variable "resource_group_name" {
  description = "The name of the existing resource group"
  type        = string
}

variable "main_vnet_address_space" {
  description = "Address space for the main virtual network"
  type        = list(string)
}

variable "subnet1_prefix" {
  description = "Address prefix for the first subnet in the main VNet"
  type        = list(string)
}
