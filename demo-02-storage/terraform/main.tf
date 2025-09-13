# Demo 02: Azure Storage Account
# This demo builds on Demo 01 by adding a Storage Account
# It demonstrates resource dependencies and additional Azure services

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
  }
}

provider "azurerm" {
  features {}
}

# Generate a random suffix for unique storage account name
resource "random_string" "storage_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Create a Resource Group
resource "azurerm_resource_group" "mms_demo_02" {
  name     = "rg-mms-demo-02-${var.environment}"
  location = var.location

  tags = {
    Environment = var.environment
    Demo        = "02-storage"
    Conference  = "MMSMusic"
    Purpose     = "Terraform Demo"
  }
}

# Create a Storage Account
resource "azurerm_storage_account" "mms_storage" {
  name                     = "stmms02${random_string.storage_suffix.result}"
  resource_group_name      = azurerm_resource_group.mms_demo_02.name
  location                 = azurerm_resource_group.mms_demo_02.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_replication_type

  tags = {
    Environment = var.environment
    Demo        = "02-storage"
    Conference  = "MMSMusic"
    Purpose     = "Terraform Demo"
  }
}

# Create a Storage Container
resource "azurerm_storage_container" "mms_container" {
  name                  = "demo-container"
  storage_account_name  = azurerm_storage_account.mms_storage.name
  container_access_type = "private"
}