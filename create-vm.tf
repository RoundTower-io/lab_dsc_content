# declare the version of terraform required
terraform {
  required_version = ">= 0.11.0"
}

# delcare that we need the azurerm provider
provider "azurerm" {
  version = "~> 1.21"
}

# variables (keeps from typing the same thing over and over)
locals {
  lab_name = "dsc-lab"
}

# set up variables
variable "vm_username" {
  description = "The username for the VM"
}
variable "vm_password" {
  description = "The password for the VM"
}

# creates the resource group
resource "azurerm_resource_group" "main" {
  name = "${local.lab_name}"
  location = "eastus2"
}

# creates the virtual network
resource "azurerm_virtual_network" "main" {
  name = "${local.lab_name}-network"
  address_space = ["192.168.0.0/24"]
  location = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
}

# creates the subnet in the virtual network we just created
resource "azurerm_subnet" "default" {
  name = "default"
  resource_group_name = "${azurerm_resource_group.main.name}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix = "192.168.0.0/24"
}

# create a public ip to access this on
resource "azurerm_public_ip" "main" {
  name                = "${local.lab_name}-pip"
  resource_group_name = "${azurerm_resource_group.main.name}"
  location = "${azurerm_resource_group.main.location}"
  allocation_method   = "Static"
}

# create a network interface to use
resource "azurerm_network_interface" "main" {
  name = "${local.lab_name}-nic"
  location = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"

  ip_configuration {
    name = "ipconfiguration"
    subnet_id = "${azurerm_subnet.default.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = "${azurerm_public_ip.main.id}"
  }
}

resource "azurerm_virtual_machine" "main" {
  name = "${local.lab_name}-vm"
  location = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  network_interface_ids = ["${azurerm_network_interface.main.id}"]
  vm_size = "Standard_DS2_v2"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer = "WindowsServer"
    sku = "2016-Datacenter"
    version = "latest"
  }
  storage_os_disk {
    name = "${local.lab_name}-vm-osdisk"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name = "windowsvm"
    admin_username = "${var.vm_username}"
    admin_password = "${var.vm_password}"
  }
  os_profile_windows_config {
    
  }
}

output "windows_vm_ip_address" {
  description = "The IP address of the Windows VM that was created."
  value = "${azurerm_public_ip.main.ip_address}"
}
