resource "azurerm_public_ip" "mgmt" {
  name                = "${var.name}-mgmt-pub-ip"
  location            = var.region
  resource_group_name = var.rg
  allocation_method   = "Static"
  sku                 = "Standard"
}

/* resource "azurerm_public_ip" "public" {
  name                = "${var.name}-public-pub-ip"
  location            = var.region
  resource_group_name = var.rg
  allocation_method   = "Static"
  sku                 = "Standard"
} */

resource "azurerm_network_interface" "mgmt" {
  name                 = "${var.name}-mgmt-nic"
  location             = var.region
  resource_group_name  = var.rg
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "${var.name}-mgmt-nic"
    subnet_id                     = var.subnet
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.mgmt.id
  }

    depends_on = [azurerm_network_security_group.mgmt]
}

/* resource "azurerm_network_interface" "public" {
  name                = "${var.name}-public-nic"
  location            = var.region
  resource_group_name = var.rg

  ip_configuration {
    name                          = "${var.name}-public-nic"
    subnet_id                     = var.subnet
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.public.id
  }
  
    depends_on = [azurerm_network_security_group.public]
}
 */
resource "azurerm_network_interface" "priv" {
  name                = "${var.name}-priv-nic"
  location            = var.region
  resource_group_name = var.rg

  ip_configuration {
    name                          = "${var.name}-priv-nic"
    subnet_id                     = var.priv_subnet
    private_ip_address_allocation = "dynamic"
  }
  
    depends_on = [azurerm_network_security_group.priv]
}

resource "azurerm_network_security_group" "mgmt" {
  name                = "${var.name}-mgmt-nsg"
  location            = var.region
  resource_group_name = var.rg

  security_rule {
    name                       = "SSH"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

/* resource "azurerm_network_security_group" "public" {
  name                = "${var.name}-public-nsg"
  location            = var.region
  resource_group_name = var.rg

  security_rule {
    name                       = "Cisco"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "UDP"
    source_port_range          = "*"
    destination_port_range     = "12356-12357"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "ICMP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "ICMP"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
} */

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

resource "azurerm_network_interface_security_group_association" "mgmt" {
  network_interface_id      = azurerm_network_interface.mgmt.id
  network_security_group_id = azurerm_network_security_group.mgmt.id
}

/* resource "azurerm_network_interface_security_group_association" "public" {
  network_interface_id      = azurerm_network_interface.public.id
  network_security_group_id = azurerm_network_security_group.public.id
} */

resource "azurerm_network_interface_security_group_association" "priv" {
  network_interface_id      = azurerm_network_interface.priv.id
  network_security_group_id = azurerm_network_security_group.priv.id
}

resource "azurerm_virtual_machine" "instance" {
  name                         = var.name
  location                     = var.region
  resource_group_name          = var.rg
  network_interface_ids        = [
    azurerm_network_interface.mgmt.id, 
    #azurerm_network_interface.public.id, 
    azurerm_network_interface.priv.id
  ]
  primary_network_interface_id = azurerm_network_interface.mgmt.id
  vm_size                      = var.instance_size

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "cisco"
    offer     = "cisco-csr-1000v"
    sku       = "17_3_3-byol"
    version   = "latest"
  }

  plan {
    name      = "17_3_3-byol"
    product   = "cisco-csr-1000v"
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
    admin_password = var.password
  }
/* ssh_keys {
    username   = "azureuser"
    public_key = var.ssh_key
  }
*/
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/azureuser/.ssh/authorized_keys"
      key_data = var.ssh_key
    }
  }

  depends_on = [
    azurerm_network_interface_security_group_association.mgmt,
    azurerm_network_interface_security_group_association.public,
    azurerm_network_interface_security_group_association.priv
  ]
}