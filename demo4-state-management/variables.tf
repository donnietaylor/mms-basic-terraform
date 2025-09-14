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