# modules/create_bastion_host/variables.tf

variable "bastion_name" {
  description = "The name of the Bastion Host"
  type        = string
}

variable "location" {
  description = "The Azure region to deploy resources"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to use for the Bastion Host"
  type        = string
}

