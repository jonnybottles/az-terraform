# modules/create_vpn_gateway/variables.tf

variable "name" {
  description = "The name of the VPN Gateway"
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

variable "sku_name" {
  description = "The SKU name for the VPN Gateway"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet for the VPN Gateway"
  type        = string
}

variable "connection_name" {
  description = "The name of the VPN Gateway connection"
  type        = string
}

variable "connection_type" {
  description = "The type of the VPN Gateway connection"
  type        = string
}

variable "shared_key" {
  description = "The shared key for the VPN Gateway connection"
  type        = string
}

variable "local_network_gateway_id" {
  description = "The ID of the local network gateway"
  type        = string
}

