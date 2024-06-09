
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

resource "azurerm_virtual_machine_extension" "enable_winrm" {
  count                 = length([for vm in var.vm_configs : vm if vm.enable_powershell_remoting])
  name                  = "${element([for vm in var.vm_configs : vm.name if vm.enable_powershell_remoting], count.index)}-enable-winrm"
  virtual_machine_id    = element([for vm in azurerm_windows_virtual_machine.vm : vm.id if contains([for c in var.vm_configs : c.name if c.enable_powershell_remoting], vm.name)], count.index)
  publisher             = "Microsoft.Compute"
  type                  = "CustomScriptExtension"
  type_handler_version  = "1.10"

  settings = <<SETTINGS
    {
      "fileUris": ["https://jonnybottles.blob.core.windows.net/scripts/enable_winrm_https_template.ps1?sp=r&st=2024-06-08T20:45:25Z&se=2024-06-09T04:45:25Z&spr=https&sv=2022-11-02&sr=b&sig=Q9O%2FtUZhWV9WQcPEX3Q3Je49kT3siuxLWUjBHJDmLCM%3D"],
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File enable_winrm_https_template.ps1 -PrivateIp ${element(azurerm_network_interface.nic.*.private_ip_address, count.index)} ${length([for vm in var.vm_configs : vm if vm.create_public_ip]) > count.index ? "-PublicIp ${element(azurerm_public_ip.public_ip.*.ip_address, count.index)}" : ""}"
    }
  SETTINGS
}
