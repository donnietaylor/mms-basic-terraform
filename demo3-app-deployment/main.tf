# Demo 3: Full Application Deployment
# This demo deploys a complete web application with:
# - App Service Plan and App Service
# - Azure Database for PostgreSQL
# - Application Insights for monitoring
# - Key Vault for secrets management

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
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

# Get current client configuration
data "azurerm_client_config" "current" {}

# Random string for unique resource names
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Resource Group
resource "azurerm_resource_group" "demo3" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = "Demo"
    Conference  = "MMSMusic"
    Demo        = "3-App-Deployment"
  }
}

# App Service Plan
resource "azurerm_service_plan" "demo3" {
  name                = "asp-demo3-${random_string.suffix.result}"
  location            = azurerm_resource_group.demo3.location
  resource_group_name = azurerm_resource_group.demo3.name
  os_type             = "Linux"
  sku_name            = var.app_service_sku

  tags = {
    Environment = "Demo"
    Conference  = "MMSMusic"
    Demo        = "3-App-Deployment"
  }
}

# App Service
resource "azurerm_linux_web_app" "demo3" {
  name                = "app-demo3-mms-${random_string.suffix.result}"
  location            = azurerm_resource_group.demo3.location
  resource_group_name = azurerm_resource_group.demo3.name
  service_plan_id     = azurerm_service_plan.demo3.id

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on = false # Set to false for free tier

    application_stack {
      node_version = "18-lts"
    }
  }

  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION"   = "18.17.0"
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.demo3.instrumentation_key
    "CONFERENCE_NAME"                = "MMS Music Conference"
    "DEMO_VERSION"                   = "3.0"
  }

  tags = {
    Environment = "Demo"
    Conference  = "MMSMusic"
    Demo        = "3-App-Deployment"
  }
}

# Application Insights
resource "azurerm_application_insights" "demo3" {
  name                = "appi-demo3-${random_string.suffix.result}"
  location            = azurerm_resource_group.demo3.location
  resource_group_name = azurerm_resource_group.demo3.name
  application_type    = "web"

  tags = {
    Environment = "Demo"
    Conference  = "MMSMusic"
    Demo        = "3-App-Deployment"
  }
}

# PostgreSQL Flexible Server
resource "azurerm_postgresql_flexible_server" "demo3" {
  name                   = "psql-demo3-${random_string.suffix.result}"
  resource_group_name    = azurerm_resource_group.demo3.name
  location               = azurerm_resource_group.demo3.location
  version                = "13"
  administrator_login    = var.db_admin_username
  administrator_password = var.db_admin_password
  zone                   = "1"
  storage_mb             = 32768
  sku_name               = "B_Standard_B1ms"

  tags = {
    Environment = "Demo"
    Conference  = "MMSMusic"
    Demo        = "3-App-Deployment"
  }

  lifecycle {
    ignore_changes = [
      zone,
      high_availability.0.standby_availability_zone
    ]
  }
}

# PostgreSQL Database
resource "azurerm_postgresql_flexible_server_database" "demo3" {
  name      = "musicdemo"
  server_id = azurerm_postgresql_flexible_server.demo3.id
  collation = "en_US.utf8"
  charset   = "utf8"
}

# PostgreSQL Firewall Rule to allow Azure services
resource "azurerm_postgresql_flexible_server_firewall_rule" "demo3_azure" {
  name             = "AllowAzureServices"
  server_id        = azurerm_postgresql_flexible_server.demo3.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# Key Vault
resource "azurerm_key_vault" "demo3" {
  name                        = "kv-demo3-${random_string.suffix.result}"
  location                    = azurerm_resource_group.demo3.location
  resource_group_name         = azurerm_resource_group.demo3.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"

  # Access policy for current user/service principal
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get", "List", "Create", "Delete", "Update", "Purge", "Recover"
    ]

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Purge", "Recover"
    ]

    storage_permissions = [
      "Get", "List", "Set", "Delete", "Purge", "Recover"
    ]
  }

  tags = {
    Environment = "Demo"
    Conference  = "MMSMusic"
    Demo        = "3-App-Deployment"
  }
}

# Access policy for the App Service managed identity
resource "azurerm_key_vault_access_policy" "app_service" {
  key_vault_id = azurerm_key_vault.demo3.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_linux_web_app.demo3.identity[0].principal_id

  secret_permissions = [
    "Get", "List"
  ]
}

# Store database connection string in Key Vault
resource "azurerm_key_vault_secret" "database_url" {
  name         = "database-url"
  value        = "postgresql://${var.db_admin_username}:${var.db_admin_password}@${azurerm_postgresql_flexible_server.demo3.fqdn}:5432/${azurerm_postgresql_flexible_server_database.demo3.name}?sslmode=require"
  key_vault_id = azurerm_key_vault.demo3.id

  depends_on = [azurerm_key_vault_access_policy.app_service]
}

# Staging slot for the App Service
resource "azurerm_linux_web_app_slot" "demo3" {
  name           = "staging"
  app_service_id = azurerm_linux_web_app.demo3.id

  site_config {
    application_stack {
      node_version = "18-lts"
    }
  }

  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "18.17.0"
    "CONFERENCE_NAME"              = "MMS Music Conference - Staging"
    "DEMO_VERSION"                 = "3.0-staging"
  }
}