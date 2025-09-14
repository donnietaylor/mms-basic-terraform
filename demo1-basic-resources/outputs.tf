output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.demo1.name
}

output "resource_group_location" {
  description = "Location of the resource group"
  value       = azurerm_resource_group.demo1.location
}

output "storage_account_name" {
  description = "Name of the created storage account"
  value       = azurerm_storage_account.demo1.name
}

output "storage_account_primary_endpoint" {
  description = "Primary blob service endpoint"
  value       = azurerm_storage_account.demo1.primary_blob_endpoint
}

output "storage_container_name" {
  description = "Name of the created storage container"
  value       = azurerm_storage_container.demo1.name
}