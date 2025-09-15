variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-mms-demo4-state"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

# VM-related variables
variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
  default     = "vm-demo4-state"
}

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Admin username for the virtual machine"
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "Admin password for the virtual machine"
  type        = string
  sensitive   = true
  # This will need to be provided during deployment

  validation {
    condition     = length(var.admin_password) >= 12 && can(regex("[A-Z]", var.admin_password)) && can(regex("[a-z]", var.admin_password)) && can(regex("[0-9]", var.admin_password)) && can(regex("[^A-Za-z0-9]", var.admin_password))
    error_message = "Admin password must be at least 12 characters long and contain uppercase, lowercase, numeric, and special characters."
  }
}