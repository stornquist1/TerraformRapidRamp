terraform {
  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0"
    }
  }
}

provider "azurerm" {
  features {
  }
}

resource "azurerm_resource_group" "demo" {
  name     = "rg-demo-3"
  location = "eastus"
}

resource "azurerm_user_assigned_identity" "trigger" {
  name                = "id-trigger-change"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
}

resource "azurerm_user_assigned_identity" "demo" {
  name                = "id-demo-3"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location

  tags = {
    environment = "demo"
  }

  lifecycle {
    # create_before_destroy = true
    # prevent_destroy = true
    # replace_triggered_by = [  //to create a dependency between standalone resources
    #   azurerm_user_assigned_identity.trigger // the trigger resource will be destroyed first
    # ]
    ignore_changes = [
      tags
    ]
  }
}
