# Demo 2: Virtual Machine Deployment
# This demo shows deploying a complete VM infrastructure including
# networking, security groups, and a Linux virtual machine

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
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
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

# Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "demo2" {
  name                = var.vm_name
  location            = azurerm_resource_group.demo2.location
  resource_group_name = azurerm_resource_group.demo2.name
  size                = var.vm_size
  admin_username      = var.admin_username

  # Disable password authentication and use SSH keys
  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.demo2.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  # Custom data to install nginx
  custom_data = base64encode(file("${path.module}/cloud-init.yml"))

  tags = {
    Environment = "Demo"
    Conference  = "MMSMusic"
    Demo        = "2-VM-Deployment"
  }
}