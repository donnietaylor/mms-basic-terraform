output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.demo3.name
}

output "app_service_name" {
  description = "Name of the App Service"
  value       = azurerm_windows_web_app.demo3.name
}

output "app_service_url" {
  description = "URL of the deployed application"
  value       = "https://${azurerm_windows_web_app.demo3.default_hostname}"
}

output "staging_slot_url" {
  description = "URL of the staging deployment slot"
  value       = "https://${azurerm_windows_web_app.demo3.default_hostname}-staging.azurewebsites.net"
}

output "database_server_name" {
  description = "Name of the SQL server"
  value       = azurerm_mssql_server.demo3.name
}

output "database_fqdn" {
  description = "FQDN of the SQL server"
  value       = azurerm_mssql_server.demo3.fully_qualified_domain_name
}

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = azurerm_key_vault.demo3.name
}

output "application_insights_name" {
  description = "Name of the Application Insights instance"
  value       = azurerm_application_insights.demo3.name
}

output "application_insights_app_id" {
  description = "App ID of Application Insights"
  value       = azurerm_application_insights.demo3.app_id
}

output "deployment_summary" {
  description = "Summary of deployed resources"
  value = {
    app_service_url      = "https://${azurerm_windows_web_app.demo3.default_hostname}"
    staging_url          = "https://${azurerm_windows_web_app.demo3.default_hostname}-staging.azurewebsites.net"
    database_server      = azurerm_mssql_server.demo3.fully_qualified_domain_name
    key_vault_name       = azurerm_key_vault.demo3.name
    application_insights = azurerm_application_insights.demo3.name
    resource_group       = azurerm_resource_group.demo3.name
  }
}