
provider "azurerm" {
  features {}
}

#Reference remote state object to get values from other deployment
data "terraform_remote_state" "base_infra" {
  backend = "azurerm"

  config = {
    resource_group_name = var.backend_resource_group_name
    storage_account_name = var.backend_storage_account_name
    container_name = var.backend_container_name
    key = "base-infra.terraform.tfstate"
  }
}

resource "azurerm_resource_group" "example_rg" {
  location = var.location
  name     = "demo-virtual-machine2023"
}

resource "azurerm_network_interface" "example_nic" {
  name                = "example-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.example_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.terraform_remote_state.base_infra.outputs.subnet_id #azurerm_subnet.example_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "example" {
  name                = "example-machine"
  resource_group_name = azurerm_resource_group.example_rg.name
  location            = var.location
  size                = "Standard_F2"
  admin_username      = var.vm_admin_user_name
  admin_password      = var.vm_admin_password
  network_interface_ids = [
    azurerm_network_interface.example_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}


