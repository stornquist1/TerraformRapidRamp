resource "azurerm_virtual_network" "myVirtualNetwork" {
    name                = "${var.rg_name}-vnet"
    address_space       = var.vnet_address_space
    location            = var.location
    resource_group_name = var.rg_name
}

resource "azurerm_subnet" "mySubnet" {
    name                 = "${var.rg_name}-subnet"
    resource_group_name  = var.rg_name
    virtual_network_name = azurerm_virtual_network.myVirtualNetwork.name
    address_prefixes     = var.subnet_address_space
}