#Azure resource manager provider block
provider "azurerm" {
   version = "~>2.0"
  features {}
}

#Resource group block
#For the name enter your participantx with x being your number
resource "azurerm_resource_group" "rg" {
        name = ""
        location = "eastus"
}

#Network block
#For the name enter your participantx-network with x being your number
#For the address_space enter your 10.x.0.0/16 with x being your number
resource "azurerm_virtual_network" "main" {
  name                = ""
  address_space       = [""]
  location            = "eastus"
  resource_group_name = azurerm_resource_group.rg.name
}

#Subnet block
#For the name enter your participantx-subnet with x being your number
#For the address_prefix enter your 10.x.2.0/24 with x being your number
resource "azurerm_subnet" "internal" {
  name                 = ""
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes       = [""]
}

#Network interface block
#For the name enter your participantx-nic with x being your number
resource "azurerm_network_interface" "main" {
  name                = ""
  location            = "eastus"
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

#For the name enter your participantx-wd with x being your number
#
resource "azurerm_virtual_machine" "main" {
  name                  = ""
  location              = "eastus"
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "kochadmin"
    admin_password = "AzureLab2020"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}

