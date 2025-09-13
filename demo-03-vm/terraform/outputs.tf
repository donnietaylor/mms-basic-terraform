output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.mms_demo_03.name
}

output "public_ip_address" {
  description = "Public IP address of the VM"
  value       = azurerm_public_ip.mms_public_ip.ip_address
}

output "vm_name" {
  description = "Name of the created virtual machine"
  value       = azurerm_linux_virtual_machine.mms_vm.name
}

output "admin_username" {
  description = "Administrator username for the VM"
  value       = azurerm_linux_virtual_machine.mms_vm.admin_username
}

output "vm_password" {
  description = "Generated password for the VM (sensitive)"
  value       = random_password.vm_password.result
  sensitive   = true
}

output "ssh_private_key" {
  description = "Private SSH key for the VM (sensitive)"
  value       = tls_private_key.vm_ssh.private_key_pem
  sensitive   = true
}

output "ssh_connection_command" {
  description = "SSH command to connect to the VM"
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.mms_public_ip.ip_address}"
}