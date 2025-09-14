output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.demo4.name
}

output "resource_group_id" {
  description = "ID of the created resource group"
  value       = azurerm_resource_group.demo4.id
}

output "state_storage_account_name" {
  description = "Name of the storage account for remote state"
  value       = azurerm_storage_account.state_storage.name
}

output "state_storage_container_name" {
  description = "Name of the storage container for Terraform state"
  value       = azurerm_storage_container.state_container.name
}

output "network_security_group_name" {
  description = "Name of the network security group (for drift demo)"
  value       = azurerm_network_security_group.demo4.name
}

output "network_security_group_id" {
  description = "ID of the network security group (for drift demo)"
  value       = azurerm_network_security_group.demo4.id
}

output "application_insights_instrumentation_key" {
  description = "Application Insights instrumentation key (sensitive data example)"
  value       = azurerm_application_insights.demo4.instrumentation_key
  sensitive   = true
}

output "application_insights_connection_string" {
  description = "Application Insights connection string (sensitive data example)"
  value       = azurerm_application_insights.demo4.connection_string
  sensitive   = true
}

# Instructions for remote state setup
output "remote_state_setup_instructions" {
  description = "Instructions for setting up remote state backend"
  value       = <<EOT
Remote state backend is already configured in this demo!

Current backend configuration:
terraform {
  backend "azurerm" {
    resource_group_name  = "${azurerm_resource_group.demo4.name}"
    storage_account_name = "${azurerm_storage_account.state_storage.name}"
    container_name       = "${azurerm_storage_container.state_container.name}"
    key                  = "demo4.terraform.tfstate"
  }
}

This demo now uses remote state by default, making it suitable for GitHub Workflows.
The state is automatically stored in the Azure Storage Account created by this configuration.
EOT
}