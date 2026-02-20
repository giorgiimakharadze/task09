output "firewall_public_ip" {
  description = "Public IP address of the Azure Firewall"
  value       = azurerm_public_ip.pip.ip_address
}

output "firewall_private_ip" {
  description = "Private IP address of the Azure Firewall"
  value       = azurerm_firewall.afw.ip_configuration[0].private_ip_address
}

output "firewall_id" {
  description = "Resource ID of the Azure Firewall"
  value       = azurerm_firewall.afw.id
}

output "route_table_id" {
  description = "Resource ID of the Route Table"
  value       = azurerm_route_table.rt.id
}
