# /modules/create_ansible_inventory/outputs.tf

output "inventory_file_path" {
  value = local_file.inventory.filename
}