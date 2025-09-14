variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-mms-demo1-basic"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

variable "storage_account_name" {
  description = "Name of the storage account (must be globally unique)"
  type        = string
  default     = "sammsdemomusicconf01"
}