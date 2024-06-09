# modules/enable_winrm_over_https/variables.tf

variable "vm_configs" {
  description = "Configuration for the VMs"
  type = list(object({
    name                       = string
    size                       = string
    disk_size_gb               = number
    create_public_ip           = bool
    enable_powershell_remoting = bool
    image = object({
      publisher = string
      offer     = string
      sku       = string
    })
  }))
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

variable "vm_ids" {
  description = "The IDs of the created VMs"
  type        = list(string)
}

variable "vm_private_ips" {
  description = "The private IP addresses of the NICs attached to the VMs"
  type        = list(string)
}

variable "vm_public_ips" {
  description = "The public IP addresses of the VMs"
  type        = list(string)
}

