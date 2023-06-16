variable "location" {
  type = string
  description = "Azure Region"
  default = "eastus2"
}


variable "vm_admin_user_name" {
  type = string
  description = "VM admin user name"
  default = "xAdmin"
}

variable "vm_admin_password" {
  type = string
  description = "VM admin password"
  default = "UseKeyVault!!!"
}


##BACKEND VARIABLES

variable "backend_resource_group_name" {
  type = string
  description = "backend RG name"
}
variable "backend_storage_account_name" {
  type = string
  description = "backend storage account name"
}

variable "backend_container_name" {
  type = string
  description = "backend container name"
}

