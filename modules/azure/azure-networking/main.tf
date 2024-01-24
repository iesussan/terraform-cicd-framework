resource "azurerm_virtual_network" "network" {
  name                = var.virtual_network_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.virtual_network_address_space
  tags = var.tags
}

resource "azurerm_subnet" "subnet" {
  for_each = { for subnet in var.virtual_network_subnets : subnet.name => subnet }
  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  address_prefixes     = [each.value.address_prefix] 
  virtual_network_name = azurerm_virtual_network.network.name
  service_endpoints    = var.service_endpoints
}
