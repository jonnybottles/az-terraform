## Pull Key Vault module vars
variable "key_vault_name" {
  description = "The name of the existing Key Vault"
  type        = string
}

variable "key_vault_rg" {
  description = "The name of the resource group containing the Key Vault"
  type        = string
}

## Create Resource Group module vars
variable "subscription_id" {
  description = "The Subscription ID for Azure"
  type        = string
}

variable "new_resource_group_name" {
  description = "The name of the new resource group to create"
  type        = string
}

variable "location" {
  description = "The Azure region to deploy resources"
  type        = string
}

## Create Virtual Network module vars
variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "vnet_address_space" {
  description = "The address space for the virtual network"
  type        = list(string)
}

variable "subnets" {
  description = "The subnets to create within the virtual network"
  type = list(object({
    name             = string
    address_prefixes = list(string)
  }))
}

variable "bastion_subnet" {
  description = "The configuration for the Azure Bastion subnet"
  type = object({
    name           = string
    address_prefix = string
  })
}

## Create NSG module vars
variable "nsg_name" {
  description = "The name of the Network Security Group"
  type        = string
}

variable "security_rules" {
  description = "List of security rules"
  type = list(object({
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
}

## Create NAT Gateway module vars
variable "address_prefix" {
  description = "The address prefix for the NAT Gateway subnet"
  type        = string
  default     = "10.0.0.0/30"
}

## Bastion Host variables
variable "bastion_name" {
  description = "The name of the Bastion Host"
  type        = string
}


## Create VM module vars

variable "vm_configs" {
  description = "Configuration for the VMs"
  type = list(object({
    name             = string
    size             = string
    disk_size_gb     = number
    create_public_ip = bool
    image = object({
      publisher = string
      offer     = string
      sku       = string
    })
  }))
}

