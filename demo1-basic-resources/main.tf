# Demo 1: Basic Azure Resources
# This demo shows the transition from ClickOps to Infrastructure as Code
# by deploying a Resource Group and Storage Account

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
resource "azurerm_resource_group" "demo1" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = "Demo"
    Conference  = "MMSMusic"
    Demo        = "1-Basic-Resources"
  }
}

# Storage Account
resource "azurerm_storage_account" "demo1" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.demo1.name
  location                 = azurerm_resource_group.demo1.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    Environment = "Demo"
    Conference  = "MMSMusic"
    Demo        = "1-Basic-Resources"
  }
}

# Storage Container
resource "azurerm_storage_container" "demo1" {
  name                  = "demo-files"
  storage_account_name  = azurerm_storage_account.demo1.name
  container_access_type = "private"
}