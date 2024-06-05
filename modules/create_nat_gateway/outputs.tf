# modules/create_nat_gateway/outputs.tf

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = azurerm_nat_gateway.nat_gateway.id
}

output "nat_public_ip_id" {
  description = "The ID of the NAT Public IP"
  value       = azurerm_public_ip.nat_public_ip.id
}
