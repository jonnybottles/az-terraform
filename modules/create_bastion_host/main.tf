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
  sku                 = "Standard"
  scale_units         = 2

  copy_paste_enabled     = true
  file_copy_enabled      = true
  shareable_link_enabled = true
  tunneling_enabled      = true

  ip_configuration {
    name                 = "config-01"
    subnet_id            = var.subnet_id
    public_ip_address_id = azurerm_public_ip.bastion_public_ip.id
  }
}