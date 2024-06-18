# /modules/create_ansible_inventory/variables.tf

variable "use_public_ip" {
  description = "Whether to use public IPs for the inventory file"
  type        = bool
  default     = true
}

variable "ansible_user" {
  description = "The Ansible user"
  type        = string
}

variable "ansible_password" {
  description = "The Ansible password"
  type        = string
  sensitive   = true
}

variable "inventory_file_path" {
  description = "The path to the generated inventory file"
  type        = string
}

variable "vm_infos" {
  description = "Mapping of VM names to their information including IP and whether they are DCs"
  type = map(object({
    ip    = string
    is_dc = bool
  }))
}
