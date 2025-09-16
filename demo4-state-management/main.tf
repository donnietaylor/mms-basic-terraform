# Demo 4: Terraform State Management and Configuration Drift Detection
# This demo shows how Terraform detects and fixes configuration drift
# Uses remote state from the beginning - NO LOCAL STATE FILES

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }

  # Backend configuration provided dynamically by GitHub Actions workflow
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

# Data source to reference existing resource group
data "azurerm_resource_group" "demo4" {
  name = var.resource_group_name
}

# Network Security Group - MAIN DRIFT DEMONSTRATION TARGET
resource "azurerm_network_security_group" "demo4" {
  name                = "nsg-demo4-drift"
  location            = data.azurerm_resource_group.demo4.location
  resource_group_name = data.azurerm_resource_group.demo4.name

  # RDP rule - SECURE by default (private networks only)
  # DRIFT TEST: Manually change source to "*" in Azure Portal
  security_rule {
    name                       = "RDP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "10.0.0.0/8" # SECURE - Change to "*" for drift
    destination_address_prefix = "*"
  }

  # HTTP rule - will be deleted manually to show drift
  # DRIFT TEST: Delete this entire rule in Azure Portal
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
    Demo        = "4-State-Management"
    Purpose     = "Drift-Target"
  }
}

# Virtual Network
resource "azurerm_virtual_network" "demo4" {
  name                = "vnet-demo4"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.demo4.location
  resource_group_name = data.azurerm_resource_group.demo4.name

  tags = {
    Environment = "Demo"
    Conference  = "MMSMusic"
    Demo        = "4-State-Management"
  }
}

# Subnet for VM
resource "azurerm_subnet" "demo4" {
  name                 = "subnet-demo4"
  resource_group_name  = data.azurerm_resource_group.demo4.name
  virtual_network_name = azurerm_virtual_network.demo4.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Public IP for VM
resource "azurerm_public_ip" "demo4_vm" {
  name                = "pip-demo4-vm"
  location            = data.azurerm_resource_group.demo4.location
  resource_group_name = data.azurerm_resource_group.demo4.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Environment = "Demo"
    Conference  = "MMSMusic"
    Demo        = "4-State-Management"
  }
}

# Network Interface for VM
resource "azurerm_network_interface" "demo4_vm" {
  name                = "nic-demo4-vm"
  location            = data.azurerm_resource_group.demo4.location
  resource_group_name = data.azurerm_resource_group.demo4.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.demo4.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.demo4_vm.id
  }

  tags = {
    Environment = "Demo"
    Conference  = "MMSMusic"
    Demo        = "4-State-Management"
  }
}

# Associate NSG to Network Interface
resource "azurerm_network_interface_security_group_association" "demo4_vm" {
  network_interface_id      = azurerm_network_interface.demo4_vm.id
  network_security_group_id = azurerm_network_security_group.demo4.id
}

# Windows VM for drift demonstration
resource "azurerm_windows_virtual_machine" "demo4" {
  name                = var.vm_name
  location            = data.azurerm_resource_group.demo4.location
  resource_group_name = data.azurerm_resource_group.demo4.name
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  network_interface_ids = [
    azurerm_network_interface.demo4_vm.id,
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
    Demo        = "4-State-Management"
    Purpose     = "Drift-Target"
  }
}

# Log Analytics Workspace for Application Insights
resource "azurerm_log_analytics_workspace" "demo4" {
  name                = "law-demo4"
  location            = data.azurerm_resource_group.demo4.location
  resource_group_name = data.azurerm_resource_group.demo4.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    Environment = "Demo"
    Conference  = "MMSMusic"
    Demo        = "4-State-Management"
  }
}

# Application Insights - demonstrates sensitive data in state
resource "azurerm_application_insights" "demo4" {
  name                = "ai-demo4"
  location            = data.azurerm_resource_group.demo4.location
  resource_group_name = data.azurerm_resource_group.demo4.name
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.demo4.id

  tags = {
    Environment = "Demo"
    Conference  = "MMSMusic"
    Demo        = "4-State-Management"
    Purpose     = "Sensitive-Data-Demo"
  }
}
