# Demo 4: Terraform State Management and Drift Detection
# This demo demonstrates how Terraform state works and how it detects
# and fixes configuration drift

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.1"
    }
  }

  # Remote state backend - stores state in Azure Storage Account
  # This configuration allows the demo to work consistently in GitHub Workflows
  backend "azurerm" {
    resource_group_name  = "rg-mms-demo4-state"
    storage_account_name = "statemmsdemo4state"
    container_name       = "tfstate"
    key                  = "demo4.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# Random suffix for unique naming (where needed)
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Import block for existing resource group (to resolve state conflicts)
# Note: Update the subscription ID if using a different Azure subscription
import {
  to = azurerm_resource_group.demo4
  id = "/subscriptions/19381250-e2a4-43b0-b620-663c2a3da3c4/resourceGroups/rg-mms-demo4-state"
}

# Resource Group - This will store our state and contain our demo resources
resource "azurerm_resource_group" "demo4" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = "Demo"
    Conference  = "MMSMusic"
    Demo        = "4-State-Management"
    Purpose     = "State-Demo"
  }
}

# Import block for existing storage account (to resolve state conflicts)
# Note: Update the subscription ID if using a different Azure subscription
import {
  to = azurerm_storage_account.state_storage
  id = "/subscriptions/19381250-e2a4-43b0-b620-663c2a3da3c4/resourceGroups/rg-mms-demo4-state/providers/Microsoft.Storage/storageAccounts/statemmsdemo4state"
}

# Storage Account for remote state backend (demonstrates best practice)
# Uses a deterministic name so it can be referenced in backend configuration
resource "azurerm_storage_account" "state_storage" {
  name                     = "statemmsdemo4state"
  resource_group_name      = azurerm_resource_group.demo4.name
  location                 = azurerm_resource_group.demo4.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # Enable blob versioning for state history
  blob_properties {
    versioning_enabled = true
  }

  tags = {
    Environment = "Demo"
    Conference  = "MMSMusic"
    Demo        = "4-State-Management"
    Purpose     = "Remote-State-Storage"
  }
}

# Import block for existing storage container (to resolve state conflicts)
import {
  to = azurerm_storage_container.state_container
  id = "https://statemmsdemo4state.blob.core.windows.net/tfstate"
}

# Import block for existing network security group (to resolve state conflicts)
# Note: Update the subscription ID if using a different Azure subscription
import {
  to = azurerm_network_security_group.demo4
  id = "/subscriptions/19381250-e2a4-43b0-b620-663c2a3da3c4/resourceGroups/rg-mms-demo4-state/providers/Microsoft.Network/networkSecurityGroups/nsg-demo4-drift"
}

# Import block for existing virtual network (to resolve state conflicts)
# Note: Update the subscription ID if using a different Azure subscription
import {
  to = azurerm_virtual_network.demo4
  id = "/subscriptions/19381250-e2a4-43b0-b620-663c2a3da3c4/resourceGroups/rg-mms-demo4-state/providers/Microsoft.Network/virtualNetworks/vnet-demo4-state"
}

# Storage Container for Terraform state files
resource "azurerm_storage_container" "state_container" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.state_storage.name
  container_access_type = "private"
}

# Network Security Group - This resource will be modified to demonstrate drift
resource "azurerm_network_security_group" "demo4" {
  name                = "nsg-demo4-drift"
  location            = azurerm_resource_group.demo4.location
  resource_group_name = azurerm_resource_group.demo4.name

  # Default rule that we'll modify manually to show drift
  security_rule {
    name                       = "RDP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "10.0.0.0/8"
    destination_address_prefix = "*"
  }

  # HTTP rule that we'll delete manually to show drift detection
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
    Purpose     = "Drift-Detection"
  }
}

# Virtual Network (now includes subnet for VM)
resource "azurerm_virtual_network" "demo4" {
  name                = "vnet-demo4-state"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.demo4.location
  resource_group_name = azurerm_resource_group.demo4.name

  tags = {
    Environment = "Demo"
    Conference  = "MMSMusic"
    Demo        = "4-State-Management"
  }
}

# Subnet for VM deployment
resource "azurerm_subnet" "demo4" {
  name                 = "subnet-demo4-vm"
  resource_group_name  = azurerm_resource_group.demo4.name
  virtual_network_name = azurerm_virtual_network.demo4.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Public IP for VM
resource "azurerm_public_ip" "demo4_vm" {
  name                = "pip-demo4-vm"
  location            = azurerm_resource_group.demo4.location
  resource_group_name = azurerm_resource_group.demo4.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Environment = "Demo"
    Conference  = "MMSMusic"
    Demo        = "4-State-Management"
    Purpose     = "VM-Public-Access"
  }
}

# Network Interface for VM
resource "azurerm_network_interface" "demo4_vm" {
  name                = "nic-demo4-vm"
  location            = azurerm_resource_group.demo4.location
  resource_group_name = azurerm_resource_group.demo4.name

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
    Purpose     = "VM-Network-Interface"
  }
}

# Associate the existing NSG to the VM's Network Interface for drift demonstration
resource "azurerm_network_interface_security_group_association" "demo4_vm" {
  network_interface_id      = azurerm_network_interface.demo4_vm.id
  network_security_group_id = azurerm_network_security_group.demo4.id
}

# Windows Virtual Machine for drift demonstration
resource "azurerm_windows_virtual_machine" "demo4" {
  name                = var.vm_name
  location            = azurerm_resource_group.demo4.location
  resource_group_name = azurerm_resource_group.demo4.name
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

  # PowerShell script to install IIS and create a demo web page
  custom_data = base64encode(<<-EOF
              <powershell>
              # Install IIS Web Server
              Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole, IIS-WebServer, IIS-CommonHttpFeatures, IIS-HttpErrors, IIS-HttpLogging, IIS-RequestMonitor, IIS-Security, IIS-RequestFiltering, IIS-StaticContent -All
              
              # Create a simple index page that shows drift detection info
              $htmlContent = @"
              <!DOCTYPE html>
              <html>
              <head>
                  <title>Demo 4 - State Management & Drift Detection</title>
                  <style>
                      body { font-family: Arial, sans-serif; margin: 40px; background-color: #f0f8ff; }
                      .container { max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
                      h1 { color: #2c5aa0; text-align: center; }
                      .section { margin: 20px 0; padding: 15px; background-color: #f8f9fa; border-radius: 5px; }
                      .drift-example { background-color: #fff3cd; border-left: 4px solid #ffc107; }
                      .success { background-color: #d1edff; border-left: 4px solid #0084ff; }
                      code { background-color: #e9ecef; padding: 2px 5px; border-radius: 3px; font-family: monospace; }
                  </style>
              </head>
              <body>
                  <div class="container">
                      <h1>🎵 MMS Music Conference 🎵</h1>
                      <h2>Demo 4: State Management & Drift Detection</h2>
                      
                      <div class="section success">
                          <h3>✅ Infrastructure Deployed Successfully!</h3>
                          <p>This virtual machine was deployed using Terraform and demonstrates state management concepts.</p>
                          <p><strong>Hostname:</strong> <code>$env:COMPUTERNAME</code></p>
                          <p><strong>OS:</strong> Windows Server 2022</p>
                          <p><strong>Purpose:</strong> Terraform state and configuration drift demonstration</p>
                      </div>
                      
                      <div class="section drift-example">
                          <h3>🔧 Configuration Drift Example</h3>
                          <p>This VM is part of a demonstration showing how Terraform detects and fixes configuration drift:</p>
                          <ul>
                              <li><strong>Network Security Group:</strong> Manual changes to firewall rules</li>
                              <li><strong>Virtual Machine:</strong> Changes to VM configuration or extensions</li>
                              <li><strong>Storage Account:</strong> Modifications to blob storage settings</li>
                          </ul>
                          <p>Try making manual changes in the Azure Portal, then run <code>terraform plan</code> to see drift detection in action!</p>
                      </div>
                      
                      <div class="section">
                          <h3>🏗️ Infrastructure Components</h3>
                          <ul>
                              <li>Resource Group with state storage</li>
                              <li>Virtual Network and Subnet</li>
                              <li>Network Security Group (drift target)</li>
                              <li>Virtual Machine (this server)</li>
                              <li>Application Insights (sensitive data demo)</li>
                              <li>Storage Account (remote state backend)</li>
                          </ul>
                      </div>
                      
                      <div class="section">
                          <p><em>This page was generated automatically during VM deployment using PowerShell.</em></p>
                          <p><strong>Deployment time:</strong> $(Get-Date)</p>
                      </div>
                  </div>
              </body>
              </html>
"@
              
              # Write the HTML content to the default IIS page
              $htmlContent | Out-File -FilePath "C:\inetpub\wwwroot\index.html" -Encoding UTF8
              
              # Restart IIS to ensure it's running
              Restart-Service -Name W3SVC -Force
              </powershell>
              EOF
  )

  tags = {
    Environment = "Demo"
    Conference  = "MMSMusic"
    Demo        = "4-State-Management"
    Purpose     = "Drift-Detection-Target"
  }
}

# Application Insights for demonstrating sensitive data in state
resource "azurerm_application_insights" "demo4" {
  name                = "ai-demo4-state"
  location            = azurerm_resource_group.demo4.location
  resource_group_name = azurerm_resource_group.demo4.name
  application_type    = "web"

  tags = {
    Environment = "Demo"
    Conference  = "MMSMusic"
    Demo        = "4-State-Management"
    Purpose     = "State-Sensitive-Data"
  }
}