variable "virtual_network_name" {}
variable "resource_group_name" {}
variable "virtual_network_address_space" {}
variable "virtual_network_subnets" {}
variable "service_endpoints" {}
variable "tags" {}
#===================Azure Key Vault===================
variable "keyvault_name" {}
variable "enabled_for_disk_encryption" {}
variable "soft_delete_retention_days" {}
variable "purge_protection_enabled" {}
variable "keyvault_sku_name" {}
#=============================== AZURE KUBERNETES SERVICE ===============================#
variable "kubernetes_service_name" {}
variable "systemnode_poolname" {}
variable "systemnodes_zones" {}
variable "systemnode_count" {}
variable "systemnode_vm_size" {}
variable "identity" {}
variable "network_plugin" {}
variable "load_balancer_sku" {}
variable "log_analytics_workspace_name" {}
variable "application_code" {}
variable "resource_provider" {}
variable "kubernetes_configuration" {}
variable "admin_group_members" {}
variable "usernode_poolname" {}
variable "usernode_zones" {}
variable "usernode_vm_size" {}
variable "usernode_min_count" {}
variable "usernode_max_count" {}
variable "kubernetes_version" {}
############################################ ACR CONFIGURATION ############################################
variable "container_registry_name" {}
variable "acr_sku"{}
############################################ Azure Managed Prometheus CONFIGURATION ############################################
variable "azurerm_monitor_workspace_name" {}
############################################ Azure Managed Grafana CONFIGURATION ############################################
variable "azurerm_dashboard_grafana_name" {}
############################################ Azure Bastion Configuration ############################################
variable "azurerm_bastion_host_name" {}
variable "azurerm_public_ip_name" {}
############################################ Azure Private DNS Zone Configuration ############################################
# variable "azurerm_private_dns_zone_name" {}
#===================Azure NAT GW  Configuration===================
variable "nat_gateway_name" {}