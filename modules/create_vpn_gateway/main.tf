# modules/create_vpn_gateway/main.tf

resource "azurerm_public_ip" "vpn_gateway_public_ip" {
  name                = "${var.name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "vpn_gateway" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  type     = "Vpn"
  vpn_type = "RouteBased"

  sku = var.sku_name 

  ip_configuration {
    name                          = "${var.name}-vpngw-ipconfig"
    public_ip_address_id          = azurerm_public_ip.vpn_gateway_public_ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.subnet_id
  }

}

resource "azurerm_virtual_network_gateway_connection" "vpn_gateway_connection" {
  name                = var.connection_name
  location            = var.location
  resource_group_name = var.resource_group_name
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vpn_gateway.id
  type                = var.connection_type

  shared_key = var.shared_key

  local_network_gateway_id = var.local_network_gateway_id
}
