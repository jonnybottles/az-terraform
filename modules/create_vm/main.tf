
#create_vm/main.tf

resource "azurerm_windows_virtual_machine" "vm" {
  count                 = length(var.vm_configs)
  name                  = var.vm_configs[count.index].name
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.vm_configs[count.index].size
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]

  os_disk {
    name                 = "${var.vm_configs[count.index].name}_osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.vm_configs[count.index].image.publisher
    offer     = var.vm_configs[count.index].image.offer
    sku       = var.vm_configs[count.index].image.sku
    version   = "latest"
  }
}

resource "azurerm_network_interface" "nic" {
  count               = length(var.vm_configs)
  name                = "${var.vm_configs[count.index].name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}
