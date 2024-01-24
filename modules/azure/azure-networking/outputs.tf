output "azure_virtual_network_id" {
  value = azurerm_virtual_network.network.id
}

output "azure_virtual_network_name" {
  value = azurerm_virtual_network.network.name
}

output "subnet_info" {
  value = [for subnet in azurerm_subnet.subnet : { id = subnet.id, name = subnet.name }]
}
output "subnet_ids" {
  description = "Contains a list of the the resource id of the subnets"
  value       = { for subnet in azurerm_subnet.subnet : subnet.name => subnet.id }
}

output "azurerm_virtual_network_name" {
  value = azurerm_virtual_network.network.name
}
