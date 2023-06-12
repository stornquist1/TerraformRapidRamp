variable "location" {
  description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  type        = string
}

variable "rg_name" {
  description = "Resource Group name"
  type        = string
}

variable "vnet_address_space" {
  description = "vnet address space"
  type        = list(string)
}

variable "subnet_address_space" {
  description = "vnet address space"
  type        = list(string)
}