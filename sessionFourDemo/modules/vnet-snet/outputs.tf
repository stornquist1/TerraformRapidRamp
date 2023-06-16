output "subnet_id" {
  description = "The id of the subnet"
  value       = azurerm_subnet.mySubnet.id
}

output "subnet_name" {
  description = "The name of the subnet"
  value       = azurerm_subnet.mySubnet.name
}

output "vnet_name" {
  description = "The name of the vnet"
  value       = azurerm_virtual_network.myVirtualNetwork.name
}