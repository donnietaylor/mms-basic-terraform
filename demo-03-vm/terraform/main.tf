# Demo 03: Azure Virtual Machine
# This demo creates a complete VM environment with networking
# It demonstrates complex resource relationships and VM configuration

terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Generate a random password for the VM
resource "random_password" "vm_password" {
  length  = 16
  special = true
}

# Generate SSH key pair
resource "tls_private_key" "vm_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create a Resource Group
resource "azurerm_resource_group" "mms_demo_03" {
  name     = "rg-mms-demo-03-${var.environment}"
  location = var.location

  tags = {
    Environment = var.environment
    Demo        = "03-vm"
    Conference  = "MMSMusic"
    Purpose     = "Terraform Demo"
  }
}

# Create a Virtual Network
resource "azurerm_virtual_network" "mms_vnet" {
  name                = "vnet-mms-demo-03"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.mms_demo_03.location
  resource_group_name = azurerm_resource_group.mms_demo_03.name

  tags = {
    Environment = var.environment
    Demo        = "03-vm"
    Conference  = "MMSMusic"
    Purpose     = "Terraform Demo"
  }
}

# Create a Subnet
resource "azurerm_subnet" "mms_subnet" {
  name                 = "subnet-internal"
  resource_group_name  = azurerm_resource_group.mms_demo_03.name
  virtual_network_name = azurerm_virtual_network.mms_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Create a Public IP
resource "azurerm_public_ip" "mms_public_ip" {
  name                = "pip-mms-demo-03-vm"
  resource_group_name = azurerm_resource_group.mms_demo_03.name
  location            = azurerm_resource_group.mms_demo_03.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Environment = var.environment
    Demo        = "03-vm"
    Conference  = "MMSMusic"
    Purpose     = "Terraform Demo"
  }
}

# Create a Network Security Group and rule
resource "azurerm_network_security_group" "mms_nsg" {
  name                = "nsg-mms-demo-03"
  location            = azurerm_resource_group.mms_demo_03.location
  resource_group_name = azurerm_resource_group.mms_demo_03.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
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
    Environment = var.environment
    Demo        = "03-vm"
    Conference  = "MMSMusic"
    Purpose     = "Terraform Demo"
  }
}

# Create a Network Interface
resource "azurerm_network_interface" "mms_nic" {
  name                = "nic-mms-demo-03-vm"
  location            = azurerm_resource_group.mms_demo_03.location
  resource_group_name = azurerm_resource_group.mms_demo_03.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mms_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mms_public_ip.id
  }

  tags = {
    Environment = var.environment
    Demo        = "03-vm"
    Conference  = "MMSMusic"
    Purpose     = "Terraform Demo"
  }
}

# Associate Network Security Group to the Network Interface
resource "azurerm_network_interface_security_group_association" "mms_nsg_association" {
  network_interface_id      = azurerm_network_interface.mms_nic.id
  network_security_group_id = azurerm_network_security_group.mms_nsg.id
}

# Create a Virtual Machine
resource "azurerm_linux_virtual_machine" "mms_vm" {
  name                = "vm-mms-demo-03"
  resource_group_name = azurerm_resource_group.mms_demo_03.name
  location            = azurerm_resource_group.mms_demo_03.location
  size                = var.vm_size
  admin_username      = var.admin_username

  # Uncomment this line to disable password authentication
  disable_password_authentication = false
  admin_password                  = random_password.vm_password.result

  network_interface_ids = [
    azurerm_network_interface.mms_nic.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = tls_private_key.vm_ssh.public_key_openssh
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

  tags = {
    Environment = var.environment
    Demo        = "03-vm"
    Conference  = "MMSMusic"
    Purpose     = "Terraform Demo"
  }
}