variable "resource_group_name" {
  description = "The name of the resource group in which to create the virtual network"
  type        = string
}
variable "location" {
  description = "The location/region where the virtual network is created"
  type        = string
  validation {
    condition     = can(regex("^(eastus|eastus2|centralus)$", var.location))
    error_message = "The location must be a valid Azure location."
  }
}
variable "azurerm_public_ip_name" {
  description = "The name of the public IP address"
  type        = string
}
variable "azurerm_public_ip_allocation_method" {
    description = "The allocation method of the public IP address"
    type        = string
    default     = "Static"
}
variable "azurerm_public_ip_sku" {
    description = "The SKU of the Public IP address"
    type        = string
    default     = "Standard"
}
variable "azurerm_bastion_host_name" {
    description = "The name of the bastion host"
    type        = string
}
variable "azurerm_bastion_host_sku" {
    description = "The SKU of the bastion host"
    type        = string
    default     = "Standard"
}
variable "azurerm_bastion_host_ip_configuration_subnet_id" {
  type        = string
  description = "The ID of the subnet to place the bastion in."
}
variable "azurerm_bastion_host_tunneling_enabled" {
  description = "Enable RDP tunneling through Azure Bastion"
  type        = bool
  default     = true
}
variable "azurerm_bastion_host_copy_paste_enabled" {
  description = "Enable copy and paste through Azure Bastion"
  type        = bool
  default     = true  
}
# variable "subnet_jumphost_id" {
#   type        = string
#   description = "The ID of the subnet to place vm interface in"
# }
