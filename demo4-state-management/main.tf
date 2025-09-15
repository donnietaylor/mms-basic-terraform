# Demo 4: Terraform State Management and Drift Detection
# This demo demonstrates how Terraform detects and fixes configuration drift
# Focus: Network Security Group rules and VM configuration changes

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

  # Remote state backend - stored in the same RG for easy cleanup
  # Backend configuration will be set dynamically during deployment
  backend "azurerm" {
    # Values set via GitHub Actions:
    # resource_group_name  = "rg-mms-demo4-state"  
    # storage_account_name = "stdemo4<random>"
    # container_name       = "tfstate"
    # key                  = "demo4.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# Random suffix for unique naming to avoid conflicts
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Resource Group - Contains all demo resources including state storage
resource "azurerm_resource_group" "demo4" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = "Demo"
    Conference  = "MMSMusic"  
    Demo        = "4-State-Management"
    Purpose     = "Drift-Demo"
  }
}

# Storage Account for remote state backend
resource "azurerm_storage_account" "state_storage" {
  name                     = "stdemo4${random_string.suffix.result}"
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

# Storage Container for Terraform state files
resource "azurerm_storage_container" "state_container" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.state_storage.name
  container_access_type = "private"
}

# Network Security Group - THE MAIN DRIFT DEMONSTRATION TARGET
resource "azurerm_network_security_group" "demo4" {
  name                = "nsg-demo4-drift-${random_string.suffix.result}"
  location            = azurerm_resource_group.demo4.location
  resource_group_name = azurerm_resource_group.demo4.name

  # RDP rule - RESTRICTED to private networks only (drift target #1)
  # In Portal: Change source from "10.0.0.0/8" to "*" to show insecure drift
  security_rule {
    name                       = "RDP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "10.0.0.0/8"  # SECURE - Private networks only
    destination_address_prefix = "*"
  }

  # HTTP rule - (drift target #2)  
  # In Portal: Delete this rule to show missing configuration drift
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
    Purpose     = "Drift-Detection-Target"
  }
}

# Virtual Network
resource "azurerm_virtual_network" "demo4" {
  name                = "vnet-demo4-${random_string.suffix.result}"
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
  name                = "pip-demo4-vm-${random_string.suffix.result}"
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
  name                = "nic-demo4-vm-${random_string.suffix.result}"
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

# Associate NSG to Network Interface for drift demonstration
resource "azurerm_network_interface_security_group_association" "demo4_vm" {
  network_interface_id      = azurerm_network_interface.demo4_vm.id
  network_security_group_id = azurerm_network_security_group.demo4.id
}

# Windows Virtual Machine - DRIFT DEMONSTRATION TARGET
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

  # PowerShell script to configure the VM for drift demonstration
  custom_data = base64encode(<<-EOF
              <powershell>
              # Install IIS Web Server
              Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole, IIS-WebServer, IIS-CommonHttpFeatures, IIS-HttpErrors, IIS-HttpLogging, IIS-RequestMonitor, IIS-Security, IIS-RequestFiltering, IIS-StaticContent -All
              
              # Create drift demonstration web page
              $htmlContent = @"
              <!DOCTYPE html>
              <html>
              <head>
                  <title>Demo 4 - Configuration Drift Detection</title>
                  <style>
                      body { font-family: Arial, sans-serif; margin: 40px; background-color: #f0f8ff; }
                      .container { max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
                      h1 { color: #2c5aa0; text-align: center; }
                      .section { margin: 20px 0; padding: 15px; background-color: #f8f9fa; border-radius: 5px; }
                      .drift-target { background-color: #fff3cd; border-left: 4px solid #ffc107; }
                      .secure { background-color: #d1edff; border-left: 4px solid #0084ff; }
                      .warning { background-color: #f8d7da; border-left: 4px solid #dc3545; }
                      code { background-color: #e9ecef; padding: 2px 5px; border-radius: 3px; font-family: monospace; }
                  </style>
              </head>
              <body>
                  <div class="container">
                      <h1>🎵 MMS Music Conference 🎵</h1>
                      <h2>Demo 4: Configuration Drift Detection</h2>
                      
                      <div class="section secure">
                          <h3>✅ Infrastructure Deployed Successfully!</h3>
                          <p>This VM demonstrates Terraform's ability to detect and fix configuration drift.</p>
                          <p><strong>Hostname:</strong> <code>$env:COMPUTERNAME</code></p>
                          <p><strong>OS:</strong> Windows Server 2022</p>
                          <p><strong>Deployment:</strong> $(Get-Date)</p>
                      </div>
                      
                      <div class="section drift-target">
                          <h3>🎯 DRIFT DEMONSTRATION TARGETS</h3>
                          <h4>1. Network Security Group</h4>
                          <p><strong>Current (Secure):</strong> RDP access from private networks only (10.0.0.0/8)</p>
                          <p><strong>Manual Change:</strong> Change RDP source to "*" (Any Source) in Azure Portal</p>
                          
                          <h4>2. HTTP Rule</h4>
                          <p><strong>Current:</strong> HTTP port 80 allowed from anywhere</p>
                          <p><strong>Manual Change:</strong> Delete this rule in Azure Portal</p>
                      </div>
                      
                      <div class="section warning">
                          <h3>⚠️ DRIFT DETECTION WORKFLOW</h3>
                          <ol>
                              <li><strong>Deploy:</strong> <code>terraform apply</code></li>
                              <li><strong>Manual Change:</strong> Modify NSG rules in Azure Portal</li>
                              <li><strong>Detect Drift:</strong> <code>terraform plan</code> (shows differences)</li>
                              <li><strong>Fix Drift:</strong> <code>terraform apply</code> (restores configuration)</li>
                              <li><strong>Verify:</strong> <code>terraform plan</code> (no changes)</li>
                          </ol>
                      </div>
                      
                      <div class="section">
                          <h3>🏗️ Infrastructure Components</h3>
                          <ul>
                              <li>Resource Group (contains everything for easy cleanup)</li>
                              <li>Storage Account (remote state backend)</li>
                              <li>Virtual Network & Subnet</li>
                              <li>Network Security Group (main drift target)</li>
                              <li>Virtual Machine (this server)</li>
                              <li>Application Insights (sensitive data example)</li>
                          </ul>
                      </div>
                  </div>
              </body>
              </html>
"@
              
              # Write the HTML content to the default IIS page
              $htmlContent | Out-File -FilePath "C:\inetpub\wwwroot\index.html" -Encoding UTF8
              
              # Restart IIS
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

# Application Insights - demonstrates sensitive data in state
resource "azurerm_application_insights" "demo4" {
  name                = "ai-demo4-${random_string.suffix.result}"
  location            = azurerm_resource_group.demo4.location
  resource_group_name = azurerm_resource_group.demo4.name
  application_type    = "web"

  tags = {
    Environment = "Demo"
    Conference  = "MMSMusic"
    Demo        = "4-State-Management"
    Purpose     = "Sensitive-Data-In-State"
  }
}