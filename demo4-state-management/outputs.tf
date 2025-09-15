# Demo 4 Outputs: Information needed for drift demonstration

# Resource Group ID
output "resource_group_id" {
  description = "ID of the resource group containing all demo resources"
  value       = azurerm_resource_group.demo4.id
}

# Network Security Group ID - Main drift target
output "network_security_group_id" {
  description = "ID of the NSG for drift demonstration"
  value       = azurerm_network_security_group.demo4.id
}

# NSG Name for Azure Portal access
output "network_security_group_name" {
  description = "Name of the NSG to find in Azure Portal"
  value       = azurerm_network_security_group.demo4.name
}

# VM Public IP for RDP testing
output "vm_public_ip" {
  description = "Public IP address of the Windows VM"
  value       = azurerm_public_ip.demo4_vm.ip_address
}

# Application Insights instrumentation key (sensitive)
output "application_insights_key" {
  description = "Application Insights instrumentation key (shows sensitive data in state)"
  value       = azurerm_application_insights.demo4.instrumentation_key
  sensitive   = true
}

# Remote state setup instructions (for GitHub Actions workflow)
output "remote_state_setup_instructions" {
  description = "Instructions for setting up remote state backend"
  value       = <<-EOT
**Remote State Backend Configuration:**
- Storage Account: ${azurerm_storage_account.terraform_state.name}
- Container: ${azurerm_storage_container.terraform_state.name}
- Resource Group: ${azurerm_resource_group.demo4.name}
- State Key: demo4.tfstate

**Next time, initialize with:**
```bash
terraform init \
  -backend-config="resource_group_name=${azurerm_resource_group.demo4.name}" \
  -backend-config="storage_account_name=${azurerm_storage_account.terraform_state.name}" \
  -backend-config="container_name=${azurerm_storage_container.terraform_state.name}" \
  -backend-config="key=demo4.tfstate"
```
  EOT
}

# Drift Demonstration Instructions
output "drift_demo_instructions" {
  description = "Step-by-step instructions for demonstrating configuration drift"
  value       = <<-EOT
    CONFIGURATION DRIFT DEMONSTRATION:
    
    1. Deploy this configuration via GitHub Actions
    
    2. Go to Azure Portal and find NSG: ${azurerm_network_security_group.demo4.name}
    
    3. DEMONSTRATE DRIFT BY:
       a) Edit RDP rule: Change source from '10.0.0.0/8' to '*' (Any)
       b) Delete the HTTP rule entirely
    
    4. Run GitHub Actions workflow with 'plan' action to see drift detection
    
    5. Run GitHub Actions workflow with 'deploy' action to fix drift
    
    6. State is stored remotely in: ${azurerm_storage_account.terraform_state.name}
    
    Resource Group: ${azurerm_resource_group.demo4.name}
    VM Public IP: ${azurerm_public_ip.demo4_vm.ip_address}
  EOT
}
