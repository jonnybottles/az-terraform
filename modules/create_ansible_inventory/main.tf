# /modules/create_ansible_inventory/main.tf

resource "local_file" "inventory" {
  content = templatefile("${path.module}/templates/inventory.tpl",
    {
      vm_infos        = var.vm_infos
      ansible_user    = var.ansible_user
      ansible_password = var.ansible_password
    }
  )
  filename = var.inventory_file_path
}
