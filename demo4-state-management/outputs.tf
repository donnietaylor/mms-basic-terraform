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

# VM-related outputs
output "vm_name" {
  description = "Name of the deployed virtual machine"
  value       = azurerm_windows_virtual_machine.demo4.name
}

output "vm_public_ip" {
  description = "Public IP address of the virtual machine"
  value       = azurerm_public_ip.demo4_vm.ip_address
}

output "vm_private_ip" {
  description = "Private IP address of the virtual machine"
  value       = azurerm_network_interface.demo4_vm.private_ip_address
}

output "vm_fqdn" {
  description = "Fully qualified domain name of the virtual machine (if configured)"
  value       = azurerm_public_ip.demo4_vm.fqdn
}

output "vm_rdp_connection" {
  description = "RDP connection command for the virtual machine"
  value       = "mstsc /v:${azurerm_public_ip.demo4_vm.ip_address}"
}

output "vm_web_url" {
  description = "URL to access the web server running on the VM"
  value       = "http://${azurerm_public_ip.demo4_vm.ip_address}"
}

# Instructions for demonstrating configuration drift
output "drift_demonstration_instructions" {
  description = "Step-by-step instructions for demonstrating configuration drift"
  value       = <<EOT
🔧 CONFIGURATION DRIFT DEMONSTRATION

Follow these steps to see how Terraform detects and fixes configuration drift:

1️⃣ DEPLOY INFRASTRUCTURE
   Run: terraform apply (or use GitHub Actions)

2️⃣ INTRODUCE DRIFT (Make manual changes in Azure Portal)
   
   🌐 Network Security Group Changes:
   Portal: https://portal.azure.com/#@/resource${azurerm_network_security_group.demo4.id}/inboundSecurityRules
   📍 NSG: ${azurerm_network_security_group.demo4.name}
   
   Manual changes to make:
   a) SSH Rule: Change source from "10.0.0.0/8" to "*" (Any source)
   b) HTTP Rule: Delete this rule entirely
   c) Add a new HTTPS rule (port 443, any source)

   🖥️ Virtual Machine Changes:
   Portal: https://portal.azure.com/#@/resource${azurerm_windows_virtual_machine.demo4.id}/overview
   📍 VM: ${azurerm_windows_virtual_machine.demo4.name}
   
   Manual changes to make:
   a) Change VM size (e.g., from Standard_B2s to Standard_B1s)
   b) Add or modify tags
   c) Change boot diagnostics settings
   d) Modify the network interface configuration

   🌐 Network Interface Changes:
   Portal: https://portal.azure.com/#@/resource${azurerm_network_interface.demo4_vm.id}/overview
   📍 NIC: ${azurerm_network_interface.demo4_vm.name}
   
   Manual changes to make:
   a) Modify IP configuration settings
   b) Change DNS servers
   c) Enable/disable IP forwarding

3️⃣ DETECT DRIFT
   Run: terraform plan
   📊 You'll see Terraform detect the changes and plan to fix them:
   
   Expected drift detection output:
   ~ azurerm_network_security_group.demo4 will be updated in-place
   ~ azurerm_windows_virtual_machine.demo4 will be updated in-place
   ~ azurerm_network_interface.demo4_vm will be updated in-place

4️⃣ FIX DRIFT
   Run: terraform apply
   🔄 Terraform will restore the original configuration

5️⃣ VERIFY
   Run: terraform plan again
   ✅ Should show "No changes" - infrastructure matches desired state
   
   🌐 Test VM Access:
   Web: ${azurerm_public_ip.demo4_vm.ip_address != "" ? "http://${azurerm_public_ip.demo4_vm.ip_address}" : "http://<VM_PUBLIC_IP>"}
   RDP: mstsc /v:${azurerm_public_ip.demo4_vm.ip_address != "" ? azurerm_public_ip.demo4_vm.ip_address : "<VM_PUBLIC_IP>"}

🎯 This demonstrates how Terraform state management prevents configuration drift across multiple resource types!
EOT
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

This demo uses remote state by default, making it suitable for GitHub Workflows.
The state is automatically stored in the Azure Storage Account created by this configuration.
EOT
}