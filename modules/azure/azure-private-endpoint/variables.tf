variable "private_endpoint_name" {
    description = "The name of the private endpoint"
    type        = string
}

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

variable "private_endpoint_subnet_id" {
  description = "The subnet id of the private endpoint"
  type        = string
}

variable "private_connection_resource_id" {
  description = "The resource id of the private connection"
  type        = string
}

variable "is_manual_connection" {
  description = "Is the connection manual"
  type        = bool
}

variable "private_dns_zone_group_ids" {
  description = "(Required) Specifies the list of Private DNS Zones to include within the private_dns_zone_group."
  type        = list(string)
}

variable "subresource_name" {
  description = "(Optional) Specifies a subresource name which the Azure Private Endpoint is able to connect to."
  type        = string
  default     = null
}

variable "private_dns_zone_group_name" {
  description = "(Required) Specifies the Name of the Private DNS Zone Group. Changing this forces a new private_dns_zone_group resource to be created."
  type        = string
}

variable "tags" {
    type = map(any)
    default = {}
    description = "Resource Group tags"
}

variable "request_message" {
  description = "(Optional) Specifies a message passed to the owner of the remote resource when the Azure Private Endpoint attempts to establish the connection to the remote resource."
  type        = string
  default     = null 
}

