# /modules/create_ansible_control_node/variables.tf

variable "ssh_key_path" {
  description = "The path to the SSH public key file"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location of the resources"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to use"
  type        = string
}

variable "network_security_group" {
  description = "The ID of the network security group"
  type        = string
}

variable "container_subnet_id" {
  description = "The ID of the subnet for the container group"
  type        = string
}

variable "vm_subnet_id" {
  description = "The ID of the subnet for the VM NIC"
  type        = string
}
