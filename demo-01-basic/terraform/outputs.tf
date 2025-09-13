output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.mms_demo_01.name
}

output "resource_group_location" {
  description = "Location of the created resource group"
  value       = azurerm_resource_group.mms_demo_01.location
}

output "resource_group_id" {
  description = "ID of the created resource group"
  value       = azurerm_resource_group.mms_demo_01.id
}