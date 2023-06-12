
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
    name     = var.rg_name
    location = "westus"
}

module "myVnet_Snet" {
    source = "./modules/vnet-snet"

    location = azurerm_resource_group.myRG.location
    rg_name = azurerm_resource_group.myRG.name
    vnet_address_space = ["10.0.0.0/16"]
    subnet_address_space = ["10.0.2.0/24"]
}

module "myVM1" {
    source = "./modules/windows-virtual-machine"
    for_each = var.vm_map

    resource_group_name = azurerm_resource_group.myRG.name
    location = azurerm_resource_group.myRG.location
    virtual_network_name = module.myVnet_Snet.vnet_name
    subnet_name = module.myVnet_Snet.subnet_name
    subnet_id = module.myVnet_Snet.subnet_id
    name = each.value.name
    size = each.value.size
}


resource "azurerm_resource_group" "myRG2" {
    name     = "secondRG"
    location = "westus"
}

module "myVnet_Snet2" {
    source = "./modules/vnet-snet"

    location = azurerm_resource_group.myRG2.location
    rg_name = azurerm_resource_group.myRG2.name
    vnet_address_space = ["10.0.0.0/16"]
    subnet_address_space = ["10.0.2.0/24"]
}

module "myVM2" {
    source = "./modules/windows-virtual-machine"
    for_each = var.vm_map

    resource_group_name = azurerm_resource_group.myRG2.name
    location = azurerm_resource_group.myRG2.location
    virtual_network_name = module.myVnet_Snet2.vnet_name
    subnet_name = module.myVnet_Snet2.subnet_name
    subnet_id = module.myVnet_Snet2.subnet_id
    name = each.value.name
    size = each.value.size
}