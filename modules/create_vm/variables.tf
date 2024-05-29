
# create_vm/variables.tf

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location of the VMs"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet"
  type        = string
}

variable "admin_username" {
  description = "The admin username for the VMs"
  type        = string
}

variable "admin_password" {
  description = "The admin password for the VMs"
  type        = string
  sensitive   = true
}

variable "vm_configs" {
  description = "Configuration for the VMs"
  type = list(object({
    name = string
    size = string
    image = object({
      publisher = string
      offer     = string
      sku       = string
    })
  }))
}
