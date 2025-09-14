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
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
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

# Virtual Network (simple one for completeness)
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

# Application Insights for demonstrating sensitive data in state
resource "azurerm_application_insights" "demo4" {
  name                = "ai-demo4-${random_string.suffix.result}"
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