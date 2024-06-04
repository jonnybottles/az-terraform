# modules/create_bastion_host/main.tf

resource "azurerm_public_ip" "bastion_public_ip" {
  name                = "${var.bastion_name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
  name                = var.bastion_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"  # Set SKU to Standard
  ip_connect_enabled = true  # Enable IP-based connectivity
  file_copy_enabled = true

  ip_configuration {
    name                 = "${var.bastion_name}-ipconfig"
    subnet_id            = var.subnet_id
    public_ip_address_id = azurerm_public_ip.bastion_public_ip.id
  }


}

