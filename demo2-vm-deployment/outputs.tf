output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.demo2.name
}

output "virtual_network_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.demo2.name
}

output "public_ip_address" {
  description = "Public IP address of the VM"
  value       = azurerm_public_ip.demo2.ip_address
}

output "vm_name" {
  description = "Name of the virtual machine"
  value       = azurerm_linux_virtual_machine.demo2.name
}

output "ssh_connection_command" {
  description = "SSH command to connect to the VM"
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.demo2.ip_address}"
}

output "web_url" {
  description = "URL to access the web server"
  value       = "http://${azurerm_public_ip.demo2.ip_address}"
}