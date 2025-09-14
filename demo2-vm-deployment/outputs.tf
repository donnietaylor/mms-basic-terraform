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
  value       = azurerm_windows_virtual_machine.demo2.name
}

output "rdp_connection_command" {
  description = "RDP connection information for the VM"
  value       = "Connect via RDP to: ${azurerm_public_ip.demo2.ip_address}:3389 with username: ${var.admin_username}"
}