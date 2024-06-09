# create virtual network main.tf

resource "azurerm_virtual_network" "main" {
  name                = var.name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "subnet" {
  count               = length(var.subnets)
  name                = var.subnets[count.index].name
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes    = var.subnets[count.index].address_prefixes

  dynamic "delegation" {
    for_each = var.subnets[count.index].name == "containers-subnet" ? [1] : []
    content {
      name = "delegation"
      service_delegation {
        name = "Microsoft.ContainerInstance/containerGroups"
        actions = [
          "Microsoft.Network/virtualNetworks/subnets/action",
          "Microsoft.Network/virtualNetworks/subnets/join/action",
        ]
      }
    }
  }
}

resource "azurerm_subnet" "bastion_subnet" {
  name                 = var.bastion_subnet.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.bastion_subnet.address_prefix]
}

