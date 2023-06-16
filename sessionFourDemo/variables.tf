variable "location" {
  description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  type        = string
  default = "westus"
}

variable "rg_name" {
  description = "Resource Group name"
  type        = string
  default = "my-resource-group"
}

variable "vnet_address_space" {
  description = "vnet address space"
  type        = list(string)
  default = ["10.0.0.0/16"]
}

variable "subnet_name" {
  description = "Subnet name"
  type        = string
  default = "my-subnet"
}

variable "subnet_address_space" {
  description = "vnet address space"
  type        = list(string)
  default = ["10.0.2.0/24"]
}

variable "vm_name" {
  description = "Virtual Machine name"
  type        = string
  default = "my-VM"
}

variable "vm_size" {
  description = "Virtual Machine size"
  type        = string
  default = "Standard_F2"
}

variable "vm_map" {
    description = "map of vm values"
    type = map(object({
        name = string
        size = string
    }))
    default = {
        "vm1" = {
            name = "my-F2-vm"
            size = "Standard_F2"
        },
        "vm2" = {
            name = "my-A1-vm"
            size = "Standard_A1_v2"
        },
        "vm3" = {
            name = "my-A1-vm-1"
            size = "Standard_A1_v2"
        }
    }
}