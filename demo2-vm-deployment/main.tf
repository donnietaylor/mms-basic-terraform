# Demo 2: Windows Virtual Machine Deployment
# This demo shows deploying a complete VM infrastructure including
# networking, security groups, and a Windows virtual machine

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "demo2" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = "Demo"
    Conference  = "MMSMusic"
    Demo        = "2-VM-Deployment"
  }
}

# Virtual Network
resource "azurerm_virtual_network" "demo2" {
  name                = "vnet-demo2"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.demo2.location
  resource_group_name = azurerm_resource_group.demo2.name

  tags = {
    Environment = "Demo"
    Conference  = "MMSMusic"
    Demo        = "2-VM-Deployment"
  }
}

# Subnet
resource "azurerm_subnet" "demo2" {
  name                 = "subnet-demo2"
  resource_group_name  = azurerm_resource_group.demo2.name
  virtual_network_name = azurerm_virtual_network.demo2.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Public IP
resource "azurerm_public_ip" "demo2" {
  name                = "pip-demo2-vm"
  location            = azurerm_resource_group.demo2.location
  resource_group_name = azurerm_resource_group.demo2.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Environment = "Demo"
    Conference  = "MMSMusic"
    Demo        = "2-VM-Deployment"
  }
}

# Network Security Group
resource "azurerm_network_security_group" "demo2" {
  name                = "nsg-demo2"
  location            = azurerm_resource_group.demo2.location
  resource_group_name = azurerm_resource_group.demo2.name

  security_rule {
    name                       = "RDP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*" # In production, restrict this to specific IPs
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Environment = "Demo"
    Conference  = "MMSMusic"
    Demo        = "2-VM-Deployment"
  }
}

# Network Interface
resource "azurerm_network_interface" "demo2" {
  name                = "nic-demo2-vm"
  location            = azurerm_resource_group.demo2.location
  resource_group_name = azurerm_resource_group.demo2.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.demo2.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.demo2.id
  }

  tags = {
    Environment = "Demo"
    Conference  = "MMSMusic"
    Demo        = "2-VM-Deployment"
  }
}

# Associate Network Security Group to Network Interface
resource "azurerm_network_interface_security_group_association" "demo2" {
  network_interface_id      = azurerm_network_interface.demo2.id
  network_security_group_id = azurerm_network_security_group.demo2.id
}

# Windows Virtual Machine
resource "azurerm_windows_virtual_machine" "demo2" {
  name                = var.vm_name
  location            = azurerm_resource_group.demo2.location
  resource_group_name = azurerm_resource_group.demo2.name
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  network_interface_ids = [
    azurerm_network_interface.demo2.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }

  tags = {
    Environment = "Demo"
    Conference  = "MMSMusic"
    Demo        = "2-VM-Deployment"
  }
}

# Windows VM Extension to install IIS and setup demo page
resource "azurerm_virtual_machine_extension" "demo2" {
  name                 = "install-iis"
  virtual_machine_id   = azurerm_windows_virtual_machine.demo2.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  protected_settings = jsonencode({
    "commandToExecute" = "powershell -ExecutionPolicy Unrestricted -EncodedCommand ${base64encode(file("${path.module}/setup-iis.ps1"))}"
  })

  tags = {
    Environment = "Demo"
    Conference  = "MMSMusic"
    Demo        = "2-VM-Deployment"
  }
}