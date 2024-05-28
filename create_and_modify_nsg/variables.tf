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

variable "nsg_name" {
  description = "The name of the Network Security Group"
  type        = string
  default     = "mainNSG"
}

variable "nsg_location" {
  description = "The location for the Network Security Group"
  type        = string
  default     = "East US"
}

variable "subnet1_nsg_rules" {
  description = "Security rules for the first subnet"
  type        = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = [
    {
      name                       = "allow-ssh"
      priority                   = 1001
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "allow-http"
      priority                   = 1002
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
}