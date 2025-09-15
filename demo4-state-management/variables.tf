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

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC7XtJyRVA+a2+kTU8o1e1qDfGhR8hVKJNyMYaXtH7wJF0tU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL3VxFqU0qU2kL demo4-vm-key"

  validation {
    condition     = can(regex("^ssh-rsa|^ssh-ed25519", var.ssh_public_key))
    error_message = "SSH public key must be in valid format (ssh-rsa or ssh-ed25519)."
  }
}