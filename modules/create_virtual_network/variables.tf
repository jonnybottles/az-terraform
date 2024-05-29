#create virtual network variables.tf

variable "name" {
  description = "The name of the virtual network"
  type        = string
}

variable "address_space" {
  description = "The address space for the virtual network"
  type        = list(string)
}

variable "location" {
  description = "The location of the virtual network"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "subnets" {
  description = "The subnets to create within the virtual network"
  type = list(object({
    name           = string
    address_prefixes = list(string)
  }))
}
