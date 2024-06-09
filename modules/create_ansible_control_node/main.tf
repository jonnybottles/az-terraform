# /modules/create_ansible_control_node/main.tf

resource "azurerm_public_ip" "control_node_pip" {
  name                = "control-node-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_container_group" "control_node" {
  name                = "control-node"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"

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
      empty_dir = true
    }
  }

  ip_address_type = "Public"
  dns_name_label  = "controlnode"
  restart_policy  = "OnFailure"

  tags = {
    environment = "test"
  }

  depends_on = [
    azurerm_public_ip.control_node_pip
  ]
}
