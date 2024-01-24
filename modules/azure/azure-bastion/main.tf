# Bastion
resource "azurerm_public_ip" "bastion" {
  name                = var.azurerm_public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.azurerm_public_ip_allocation_method
  sku                 = var.azurerm_public_ip_sku
}
resource "azurerm_bastion_host" "this" {
  name                = var.azurerm_public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.azurerm_bastion_host_sku
  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.azurerm_bastion_host_ip_configuration_subnet_id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
  tunneling_enabled  = var.azurerm_bastion_host_tunneling_enabled
  copy_paste_enabled = var.azurerm_bastion_host_copy_paste_enabled
}
