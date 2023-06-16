# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

data "azurerm_resource_group" "vm_resource_group" {
  name = "test1"
}

# #no loner have to track ID, exposes more values
# # Data blocks are commonly used with key vault
# # block is able to pull other data
# data "azurerm_subnet" "vm_subnet" {
#   name                 = var.subnet_name
#   virtual_network_name = var.virtual_network_name
#   resource_group_name  = var.resource_group_name
# }

resource "azurerm_network_interface" "windows_vm" {
  name                = "${var.name}_NIC"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "${var.name}_IPCONFIG"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "windows_vm" {
  depends_on = [azurerm_network_interface.windows_vm]
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.windows_vm.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  
}
