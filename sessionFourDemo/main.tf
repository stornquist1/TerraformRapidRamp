
terraform {
    required_providers {
    azurerm = {
        source  = "hashicorp/azurerm"
        version = "~> 3.0.2"
    }
    }

    required_version = ">= 1.1.0"
}

provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "myRG" {
    name     = "my-resource-group"
    location = var.location
}

resource "azurerm_virtual_network" "myVirtualNetwork" {
    name                = "my-virtual-network"
    address_space       = ["10.0.0.0/16"]
    location            = azurerm_resource_group.myRG.location
    resource_group_name = azurerm_resource_group.myRG.name
}

resource "azurerm_subnet" "mySubnet" {
    name                 = "my-subnet"
    resource_group_name  = azurerm_resource_group.myRG.name
    virtual_network_name = azurerm_virtual_network.myVirtualNetwork.name
    address_prefixes     = ["10.0.2.0/24"]
}

module "myVM1" {
    source = "./modules/windows-virtual-machine"
    resource_group_name = azurerm_resource_group.myRG.name
    location = var.location
    virtual_network_name = azurerm_virtual_network.myVirtualNetwork.name
    subnet_name = azurerm_subnet.mySubnet.name
    vm_subnet_id = azurerm_subnet.mySubnet.id
    name = "my-VM-1"
    size = "Standard_F2"
    admin_username = "azureuser"
    admin_password = "rapidRamp1"
}