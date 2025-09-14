variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-mms-demo3-app"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US 2"
}

variable "app_service_sku" {
  description = "SKU for the App Service Plan"
  type        = string
  default     = "F1" # Free tier for demo
  validation {
    condition     = contains(["F1", "B1", "B2", "B3", "S1", "S2", "S3", "P1v2", "P2v2", "P3v2"], var.app_service_sku)
    error_message = "App Service SKU must be a valid Azure App Service plan SKU."
  }
}

variable "db_admin_username" {
  description = "Administrator username for SQL server"
  type        = string
  default     = "sqladmin"
}

variable "db_admin_password" {
  description = "Administrator password for SQL server"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.db_admin_password) >= 8
    error_message = "Database password must be at least 8 characters long."
  }
}