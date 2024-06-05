# modules/create_nat_gateway/main.tf

resource "azurerm_public_ip" "nat_public_ip" {
  name                = "nat-gateway-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip_prefix" "nat_public_ip_prefix" {
  name                = "nat-gateway-prefix"
  location            = var.location
  resource_group_name = var.resource_group_name
  prefix_length       = var.prefix_length
  sku                 = "Standard"
}

resource "azurerm_nat_gateway" "nat_gateway" {
  name                = "nat-gateway"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Standard"
}

resource "azurerm_nat_gateway_public_ip_association" "nat_gateway_public_ip_assoc" {
  nat_gateway_id       = azurerm_nat_gateway.nat_gateway.id
  public_ip_address_id = azurerm_public_ip.nat_public_ip.id
}

resource "azurerm_nat_gateway_public_ip_prefix_association" "nat_gateway_public_ip_prefix_assoc" {
  nat_gateway_id        = azurerm_nat_gateway.nat_gateway.id
  public_ip_prefix_id   = azurerm_public_ip_prefix.nat_public_ip_prefix.id
}

resource "azurerm_subnet_nat_gateway_association" "subnet_nat_gateway_assoc" {
  subnet_id      = var.subnet_id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}

