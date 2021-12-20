resource "azurerm_public_ip" "public" {
  name                = "${var.name}-public-pub-ip"
  location            = var.region
  resource_group_name = var.rg
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "public" {
  name                 = "${var.name}-public-nic"
  location             = var.region
  resource_group_name  = var.rg
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "${var.name}-public-nic"
    subnet_id                     = var.subnet
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.public.id
  }

    depends_on = [azurerm_network_security_group.public]
}

resource "azurerm_network_interface" "priv" {
  name                 = "${var.name}-priv-nic"
  location             = var.region
  resource_group_name  = var.rg
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "${var.name}-priv-nic"
    subnet_id                     = var.priv_subnet
    private_ip_address_allocation = "dynamic"
  }
  
    depends_on = [azurerm_network_security_group.priv]
}

resource "azurerm_network_security_group" "public" {
  name                = "${var.name}-public-nsg"
  location            = var.region
  resource_group_name = var.rg

  security_rule {
    name                       = "ICMP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "ICMP"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "DTLS"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "UDP"
    source_port_range          = "*"
    destination_port_range     = "12346-13156"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH from CH01"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "185.112.52.0/22"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH from CH02"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "194.30.181.0/24"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "vbond-4"
    priority                   = 1004
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "52.221.135.94/32"
    destination_address_prefix = "*"
  }

###

  security_rule {
    name                       = "vsmart-5"
    priority                   = 1005
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "54.151.139.68/32"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "vmanage"
    priority                   = 1006
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "52.29.35.167/32"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "vsmart-4"
    priority                   = 1007
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "34.192.15.19/32"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "vbond-3"
    priority                   = 1008
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "18.235.204.12/32"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "vbond-2"
    priority                   = 1009
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "54.74.48.147/32"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "vsmart-1"
    priority                   = 1010
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "18.192.225.137/32"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "vsmart-3"
    priority                   = 1011
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "52.5.190.61/32"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "vsmart-2"
    priority                   = 1012
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "54.74.133.23/32"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "vbond-1"
    priority                   = 1013
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "18.158.122.46/32"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "vsmart-6"
    priority                   = 1014
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "18.140.33.99/32"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "outbound"
    priority                   = 1015
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

resource "azurerm_network_security_group" "priv" {
  name                = "${var.name}-priv-nsg"
  location            = var.region
  resource_group_name = var.rg

  security_rule {
    name                       = "All"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "public" {
  network_interface_id      = azurerm_network_interface.public.id
  network_security_group_id = azurerm_network_security_group.public.id
}

resource "azurerm_network_interface_security_group_association" "priv" {
  network_interface_id      = azurerm_network_interface.priv.id
  network_security_group_id = azurerm_network_security_group.priv.id
}

resource "azurerm_virtual_machine" "instance" {
  name                         = var.name
  location                     = var.region
  resource_group_name          = var.rg
  network_interface_ids        = [
    azurerm_network_interface.public.id, 
    azurerm_network_interface.priv.id
  ]
  primary_network_interface_id = azurerm_network_interface.public.id
  vm_size                      = var.instance_size

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "cisco"
    offer     = "cisco_cloud_cedge"
    sku       = "cisco_cloud_csr_1000_17_3_3"
    version   = "latest"
  }

  plan {
    name      = "cisco_cloud_csr_1000_17_3_3"
    product   = "cisco_cloud_cedge"
    publisher = "cisco"
  }

  storage_os_disk {
    name                 = "${var.name}-osdisk"
    caching              = "ReadWrite"
    create_option        = "FromImage"
    managed_disk_type    = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.name}-vm"
    admin_username = "azureuser"
#    admin_password = var.password
    custom_data    = var.user_data
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/azureuser/.ssh/authorized_keys"
      key_data = var.ssh_key
    }
  }

  depends_on = [
    azurerm_network_interface_security_group_association.public,
    azurerm_network_interface_security_group_association.priv
  ]
}
