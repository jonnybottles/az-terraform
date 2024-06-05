# modules/create_nat_gateway/variables.tf

variable "location" {
  description = "The Azure region to deploy resources"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet"
  type        = string
}

variable "prefix_length" {
  description = "The prefix length for the public IP prefix"
  type        = number
  default     = 30
}
