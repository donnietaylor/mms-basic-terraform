variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "East US"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "app_service_plan_sku" {
  description = "The SKU for the App Service Plan"
  type        = string
  default     = "B1"
  validation {
    condition = contains([
      "F1", "D1", "B1", "B2", "B3", "S1", "S2", "S3", "P1v2", "P2v2", "P3v2"
    ], var.app_service_plan_sku)
    error_message = "App Service Plan SKU must be a valid Azure App Service Plan SKU."
  }
}

variable "node_version" {
  description = "Node.js version for the web app"
  type        = string
  default     = "18-lts"
  validation {
    condition = contains([
      "16-lts", "18-lts", "20-lts"
    ], var.node_version)
    error_message = "Node version must be a supported LTS version."
  }
}

variable "create_staging_slot" {
  description = "Whether to create a staging deployment slot"
  type        = bool
  default     = false
}