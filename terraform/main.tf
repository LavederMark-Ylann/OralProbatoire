# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.37.0"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "TF_VAR_Probatoire_ComputerName" {
  type = string
}

variable "TF_VAR_Probatoire_User" {
  type = string
}

variable "TF_VAR_Probatoire_Password" {
  type = string
}

# Public IP address of your current machine. Limit access by SSH to this IP address.
variable "TF_VAR_Probatoire_PublicIP" {
  type = string
}


# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "probatoire-rg"
  location = "West Europe"
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "probatoire-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create a subnet
resource "azurerm_subnet" "subnet" {
  name                 = "probatoire-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes       = ["10.0.1.0/24"]
}

# Create a public IP address
resource "azurerm_public_ip" "ip" {
  name                = "probatoire-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Create a security group
resource "azurerm_network_security_group" "nsg" {
  name                = "probatoire-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.TF_VAR_Probatoire_PublicIP
    destination_address_prefix = "*"
  }
}

# Create a network interface
resource "azurerm_network_interface" "nic" {
  name                = "probatoire-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "NIC"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ip.id
  }
}

# Create a virtual machine
resource "azurerm_virtual_machine" "vm" {
  name                  = "probatoire-linux"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_B1s"
  #vm_size               = "Standard_A4_v2"

  storage_os_disk {
    name          = "osdisk"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  os_profile {
    computer_name  = var.TF_VAR_Probatoire_ComputerName
    admin_username = var.TF_VAR_Probatoire_User
    admin_password = var.TF_VAR_Probatoire_Password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}
