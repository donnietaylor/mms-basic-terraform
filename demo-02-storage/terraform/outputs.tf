output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.mms_demo_02.name
}

output "resource_group_location" {
  description = "Location of the created resource group"
  value       = azurerm_resource_group.mms_demo_02.location
}

output "storage_account_name" {
  description = "Name of the created storage account"
  value       = azurerm_storage_account.mms_storage.name
}

output "storage_account_primary_endpoint" {
  description = "Primary blob endpoint of the storage account"
  value       = azurerm_storage_account.mms_storage.primary_blob_endpoint
}

output "storage_container_name" {
  description = "Name of the created storage container"
  value       = azurerm_storage_container.mms_container.name
}