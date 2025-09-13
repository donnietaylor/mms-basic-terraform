output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.mms_demo_04.name
}

output "app_service_name" {
  description = "Name of the created app service"
  value       = azurerm_linux_web_app.mms_web_app.name
}

output "app_service_url" {
  description = "URL of the web app"
  value       = "https://${azurerm_linux_web_app.mms_web_app.default_hostname}"
}

output "app_service_plan_name" {
  description = "Name of the app service plan"
  value       = azurerm_service_plan.mms_app_plan.name
}

output "app_service_plan_sku" {
  description = "SKU of the app service plan"
  value       = azurerm_service_plan.mms_app_plan.sku_name
}

output "application_insights_name" {
  description = "Name of Application Insights"
  value       = azurerm_application_insights.mms_app_insights.name
}

output "application_insights_instrumentation_key" {
  description = "Application Insights instrumentation key"
  value       = azurerm_application_insights.mms_app_insights.instrumentation_key
  sensitive   = true
}

output "staging_slot_url" {
  description = "URL of the staging slot (if created)"
  value       = var.create_staging_slot ? "https://${azurerm_linux_web_app.mms_web_app.default_hostname}-staging.azurewebsites.net" : null
}