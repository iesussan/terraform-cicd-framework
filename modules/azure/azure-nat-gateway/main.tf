resource "azurerm_public_ip" "nat_gategay_public_ip" {
  name                = "${var.nat_gateway_name}PublicIp"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = var.zones
  tags                = var.tags 

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_nat_gateway" "nat_gateway" {
  name                    = var.nat_gateway_name
  location                = var.location
  resource_group_name     = var.resource_group_name
  sku_name                = var.sku_name
  idle_timeout_in_minutes = var.idle_timeout_in_minutes
  zones                   = var.zones
  tags                    = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_nat_gateway_public_ip_association" "nat_gategay_public_ip_association" {
  nat_gateway_id       = azurerm_nat_gateway.nat_gateway.id
  public_ip_address_id = azurerm_public_ip.nat_gategay_public_ip.id
}

resource "azurerm_subnet_nat_gateway_association" "subnet_nat_gateway_association" {
  for_each              = var.subnet_ids
  subnet_id             = each.value
  nat_gateway_id        = azurerm_nat_gateway.nat_gateway.id
}