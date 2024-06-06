
#create_vm/main.tf

resource "azurerm_public_ip" "public_ip" {
  count               = length([for vm in var.vm_configs : vm if vm.create_public_ip])
  name                = "${element([for vm in var.vm_configs : vm.name if vm.create_public_ip], count.index)}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "nic" {
  count               = length(var.vm_configs)
  name                = "${var.vm_configs[count.index].name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "ip_configuration" {
    for_each = var.vm_configs[count.index].create_public_ip ? [1] : []
    content {
      name                          = "public"
      subnet_id                     = var.subnet_id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id          = element(azurerm_public_ip.public_ip.*.id, count.index)
      primary                       = true
    }
  }

  ip_configuration {
    name                          = "private"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    primary                       = var.vm_configs[count.index].create_public_ip ? false : true
  }
}

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
    disk_size_gb         = var.vm_configs[count.index].disk_size_gb
  }

  source_image_reference {
    publisher = var.vm_configs[count.index].image.publisher
    offer     = var.vm_configs[count.index].image.offer
    sku       = var.vm_configs[count.index].image.sku
    version   = "latest"
  }
}
