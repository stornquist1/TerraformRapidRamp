
provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "example_rg" {
  location = var.location
  name     = "demo-base-infra2023"
}

resource "azurerm_virtual_network" "example_vnet" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.example_rg.name
}

resource "azurerm_subnet" "example_subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.example_rg.name
  virtual_network_name = azurerm_virtual_network.example_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

