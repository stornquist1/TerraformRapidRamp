data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "vmterravmRG" {
  name     = "rg-TerraformLab"
  location = "eastus"
}

resource "azurerm_key_vault" "azkeyvault" {
  name                        = "kvTerraformLab145999"
  location                    = azurerm_resource_group.vmterravmRG.location
  resource_group_name         = azurerm_resource_group.vmterravmRG.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled    = false
  sku_name                    = "standard"
  access_policy {
    tenant_id           = data.azurerm_client_config.current.tenant_id
    object_id           = data.azurerm_client_config.current.object_id

    secret_permissions  = [
    "Backup",
    "Delete",
    "Get",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Set",
    ]
  }
  access_policy {
    tenant_id    = data.azurerm_client_config.current.tenant_id
    object_id    = "<Object ID of user or group to give permission>"

    secret_permissions = [
      "Backup",
      "Delete",
      "Get",
      "List",
      "Purge",
      "Recover",
      "Restore",
      "Set",
    ]
  }
}

resource "azurerm_key_vault_secret" "kvadminpass" {
  name         = "vmAdmin1"
  value        = random_password.vmadminpass.result
  key_vault_id = azurerm_key_vault.azkeyvault.id
}

resource "random_password" "vmadminpass" {
  length  = 16
  special = true
  upper   = true
}

resource "azurerm_network_security_group" "nsgjit" {
  name                = "nsgJIT"
  location            = azurerm_resource_group.vmterravmRG.location
  resource_group_name = azurerm_resource_group.vmterravmRG.name
  security_rule {
    name                       = "srjit"
    priority                   = 4095
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = azurerm_network_interface.nic-TerraformVM.private_ip_address
  }
}

resource "azurerm_subnet_network_security_group_association" "snsjit" {
  subnet_id                 = azurerm_subnet.snet-Terraform.id
  network_security_group_id = azurerm_network_security_group.nsgjit.id
}

resource "azurerm_virtual_network" "vnet-Terraform" {
  name                = "Vnet_DevOpsLab"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.vmterravmRG.location
  resource_group_name = azurerm_resource_group.vmterravmRG.name
}

resource "azurerm_subnet" "snet-Terraform" {
  name                 = "vm-subnet"
  resource_group_name  = azurerm_resource_group.vmterravmRG.name
  virtual_network_name = azurerm_virtual_network.vnet-Terraform.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "ipterraformpip" {
  name                = "pipNicDC"
  resource_group_name = azurerm_resource_group.vmterravmRG.name
  location            = azurerm_resource_group.vmterravmRG.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "nic-TerraformVM" {
  name                = "TF-nic"
  location            = azurerm_resource_group.vmterravmRG.location
  resource_group_name = azurerm_resource_group.vmterravmRG.name

  ip_configuration {
    name                          = "TF-IP-config"
    subnet_id                     = azurerm_subnet.snet-Terraform.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ipterraformpip.id
    primary                       = true
  }
}

resource "azurerm_windows_virtual_machine" "vmTerra" {
  name                = "TFSvr"
  resource_group_name = azurerm_resource_group.vmterravmRG.name
  location            = azurerm_resource_group.vmterravmRG.location
  size                = "Standard_B2ms"
  admin_username      = "adminuser"
  admin_password      = azurerm_key_vault_secret.kvadminpass.value
  network_interface_ids = [
    azurerm_network_interface.nic-TerraformVM.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

  resource "azurerm_managed_disk" "vmdatadisk" {
    name                 = "vmdisk1"
    location             = azurerm_resource_group.vmterravmRG.location
    resource_group_name  = azurerm_resource_group.vmterravmRG.name
    storage_account_type = "Standard_LRS"
    create_option        = "Empty"
    disk_size_gb         = 10
  }

  resource "azurerm_virtual_machine_data_disk_attachment" "data" {
    managed_disk_id    = azurerm_managed_disk.vmdatadisk.id
    virtual_machine_id = azurerm_windows_virtual_machine.vmTerra.id
    lun                = "10"
    caching            = "ReadWrite"
  }