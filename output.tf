output "vm" {
  description = "The created VM as an object with all of it's attributes. This was created using the azurerm_virtual_machine resource."
  value       = azurerm_virtual_machine.instance
}

output "public_nic" {
  description = "The created Mgmt NIC as an object with all of it's attributes. This was created using the azurerm_network_interface resource."
  value       = azurerm_network_interface.public
}

/* output "public_nic" {
  description = "The created Public NIC as an object with all of it's attributes. This was created using the azurerm_network_interface resource."
  value       = azurerm_network_interface.public
} */

output "priv_nic" {
  description = "The created Private NIC as an object with all of it's attributes. This was created using the azurerm_network_interface resource."
  value       = azurerm_network_interface.priv
}