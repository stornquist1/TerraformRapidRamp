# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

variable "resource_group_name" {
  description = "The name of the resource group the virtual machine resides in"
  type        = string
}

variable "location" {
  description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  type        = string
}

variable "virtual_network_name" {
  description = "The name of the virtual network the virtual machine resides in"
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnet the virtual machine resides in"
  type        = string
}

variable "subnet_id" {
  description = "The name of the subnet the virtual machine resides in"
  type        = string
}

variable "name" {
  description = "The name of the virtual machine"
  type        = string
}

variable "size" {
  description = "The size of the virtual machine"
  type        = string
}

variable "admin_username" {
  description = "The admin username of the virtual machine"
  type        = string
  default = "azureuser"
}

variable "admin_password" {
  description = "The admin password of the virtual machine"
  type        = string
  sensitive   = true
  default = "rapidRamp1"
}