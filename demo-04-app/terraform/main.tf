# Demo 04: Azure App Service
# This demo creates a complete web application environment
# It demonstrates App Service, Service Plan, and Application Insights

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

# Generate a random suffix for unique app service name
resource "random_string" "app_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Create a Resource Group
resource "azurerm_resource_group" "mms_demo_04" {
  name     = "rg-mms-demo-04-${var.environment}"
  location = var.location

  tags = {
    Environment = var.environment
    Demo        = "04-app"
    Conference  = "MMSMusic"
    Purpose     = "Terraform Demo"
  }
}

# Create an App Service Plan
resource "azurerm_service_plan" "mms_app_plan" {
  name                = "plan-mms-demo-04"
  resource_group_name = azurerm_resource_group.mms_demo_04.name
  location            = azurerm_resource_group.mms_demo_04.location
  os_type             = "Linux"
  sku_name            = var.app_service_plan_sku

  tags = {
    Environment = var.environment
    Demo        = "04-app"
    Conference  = "MMSMusic"
    Purpose     = "Terraform Demo"
  }
}

# Create Application Insights
resource "azurerm_application_insights" "mms_app_insights" {
  name                = "appi-mms-demo-04"
  location            = azurerm_resource_group.mms_demo_04.location
  resource_group_name = azurerm_resource_group.mms_demo_04.name
  application_type    = "web"

  tags = {
    Environment = var.environment
    Demo        = "04-app"
    Conference  = "MMSMusic"
    Purpose     = "Terraform Demo"
  }
}

# Create the Web App
resource "azurerm_linux_web_app" "mms_web_app" {
  name                = "app-mms-demo-04-${random_string.app_suffix.result}"
  resource_group_name = azurerm_resource_group.mms_demo_04.name
  location            = azurerm_resource_group.mms_demo_04.location
  service_plan_id     = azurerm_service_plan.mms_app_plan.id

  site_config {
    always_on = var.app_service_plan_sku == "F1" ? false : true

    application_stack {
      node_version = var.node_version
    }
  }

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"             = azurerm_application_insights.mms_app_insights.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING"      = azurerm_application_insights.mms_app_insights.connection_string
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~3"
    "XDT_MicrosoftApplicationInsights_Mode"      = "Recommended"
    "WEBSITE_NODE_DEFAULT_VERSION"               = var.node_version
    "MMS_CONFERENCE_NAME"                        = "MMSMusic"
    "DEMO_VERSION"                               = "04-app"
  }

  tags = {
    Environment = var.environment
    Demo        = "04-app"
    Conference  = "MMSMusic"
    Purpose     = "Terraform Demo"
  }
}

# Create a deployment slot for staging
resource "azurerm_linux_web_app_slot" "mms_web_app_staging" {
  count          = var.create_staging_slot ? 1 : 0
  name           = "staging"
  app_service_id = azurerm_linux_web_app.mms_web_app.id

  site_config {
    always_on = var.app_service_plan_sku == "F1" ? false : true

    application_stack {
      node_version = var.node_version
    }
  }

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"             = azurerm_application_insights.mms_app_insights.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING"      = azurerm_application_insights.mms_app_insights.connection_string
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~3"
    "XDT_MicrosoftApplicationInsights_Mode"      = "Recommended"
    "WEBSITE_NODE_DEFAULT_VERSION"               = var.node_version
    "MMS_CONFERENCE_NAME"                        = "MMSMusic"
    "DEMO_VERSION"                               = "04-app-staging"
  }

  tags = {
    Environment = "${var.environment}-staging"
    Demo        = "04-app"
    Conference  = "MMSMusic"
    Purpose     = "Terraform Demo"
  }
}