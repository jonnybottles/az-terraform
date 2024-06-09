# /modules/create_ansible_control_node/main.tf

resource "azurerm_network_interface" "control_node_nic" {
  name                = "control-node-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.vm_subnet_id
    private_ip_address_allocation = "Dynamic"
    primary                       = true
  }

  tags = {
    environment = "test"
  }
}

resource "azurerm_container_group" "control_node" {
  name                = "control-node"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  subnet_ids          = [var.container_subnet_id]

  container {
    name   = "ansible-control-node"
    image  = "xxbutler21xx/ansible-control-node:latest"
    cpu    = "1.0"
    memory = "1.5"

    ports {
      port     = 22
      protocol = "TCP"
    }

    environment_variables = {
      SSH_KEY_PATH = var.ssh_key_path
    }

    volume {
      name       = "ssh-keys"
      mount_path = "/home/ansible/.ssh"
      empty_dir  = true
    }
  }

  ip_address_type = "Private"  # Use private IP

  tags = {
    environment = "test"
  }

  depends_on = [
    azurerm_network_interface.control_node_nic
  ]
}
