# Demo 01: Basic Azure Resource Group
# This is the most basic Terraform configuration for Azure
# It creates a single Resource Group

terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Create a Resource Group
resource "azurerm_resource_group" "mms_demo_01" {
  name     = "rg-mms-demo-01-${var.environment}"
  location = var.location

  tags = {
    Environment = var.environment
    Demo        = "01-basic"
    Conference  = "MMSMusic"
    Purpose     = "Terraform Demo"
  }
}