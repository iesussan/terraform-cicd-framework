data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

data "azurerm_client_config" "current" {}

data "azurerm_log_analytics_workspace" "this"{
  name = var.log_analytics_workspace_name
  resource_group_name = data.azurerm_resource_group.resource_group.name
}

module "azure-networking"{
    source        = "../../../modules/azure/azure-networking"
    virtual_network_name = var.virtual_network_name
    resource_group_name = data.azurerm_resource_group.resource_group.name
    location = data.azurerm_resource_group.resource_group.location
    virtual_network_address_space = var.virtual_network_address_space
    virtual_network_subnets = var.virtual_network_subnets
    service_endpoints = var.service_endpoints
    tags = var.tags
}

locals {
  systemnode_subnet_id    = [for subnet in module.azure-networking.subnet_info : subnet.id if try(regex(".*SYSTEMNODE.*", subnet.name), null) != null][0]
  usernode_subnet_id      = [for subnet in module.azure-networking.subnet_info : subnet.id if try(regex(".*USERNODE.*", subnet.name), null) != null][0]
  apiserver_subnet_id     = [for subnet in module.azure-networking.subnet_info : subnet.id if try(regex(".*APISERVER.*", subnet.name), null) != null][0]
  bastion_id              = [for subnet in module.azure-networking.subnet_info : subnet.id if try(regex(".*AzureBastionSubnet.*", subnet.name), null) != null][0]
  private_endpoints_id    = [for subnet in module.azure-networking.subnet_info : subnet.id if try(regex(".*PE.*", subnet.name), null) != null][0]
  nat_gateway_id          = [for subnet in module.azure-networking.subnet_info : subnet.id if try(regex(".*NATGATEWAY.*", subnet.name), null) != null][0]
}


module "nat_gateway" {
  source                       = "../../../modules/azure/azure-nat-gateway"
  nat_gateway_name             = var.nat_gateway_name
  location                     = data.azurerm_resource_group.resource_group.location
  resource_group_name          = data.azurerm_resource_group.resource_group.name
  tags                         = var.tags
  subnet_ids                   = module.azure-networking.subnet_ids
}
###########################################################################################################################
module "azure_private_dns_zone_for_acr" {
  source                        = "../../../modules/azure/azure-private-dns-zone"
  azurerm_private_dns_zone_name = "privatelink.azurecr.io"
  resource_group_name           = data.azurerm_resource_group.resource_group.name
  tags                          = var.tags
  virtual_networks_to_link      = {
    (module.azure-networking.azure_virtual_network_name) = {
      subscription_id = data.azurerm_client_config.current.subscription_id
      resource_group_name = data.azurerm_resource_group.resource_group.name
    }
  }
}

module "azure-container-registry" {
  source = "../../../modules/azure/azure-container-registry"
  container_registry_name = var.container_registry_name
  application_code = var.application_code
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location = data.azurerm_resource_group.resource_group.location
  acr_sku = var.acr_sku
  permitted_cidr = var.virtual_network_subnets
}

module "acr_private_endpoint" {
  source                         = "../../../modules/azure/azure-private-endpoint"
  private_endpoint_name          = "${module.azure-container-registry.name}PrivateEndpoint"
  location                       = data.azurerm_resource_group.resource_group.location
  resource_group_name            = data.azurerm_resource_group.resource_group.name
  private_endpoint_subnet_id     = local.private_endpoints_id
  tags                           = var.tags
  private_connection_resource_id = module.azure-container-registry.id
  is_manual_connection           = false
  subresource_name               = "registry"
  private_dns_zone_group_name    = "AcrPrivateDnsZoneGroup"
  private_dns_zone_group_ids     = [module.azure_private_dns_zone_for_acr.azure_private_dns_zone_id]
}


module "azure-kubernetes-service" {
    source                          = "../../../modules/azure/azure-kubernetes-service"
    kubernetes_version              = var.kubernetes_version
    kubernetes_service_name         = var.kubernetes_service_name
    kubernetes_apiserver_subnet_id  = local.apiserver_subnet_id
    systemnode_poolname             = var.systemnode_poolname
    systemnodes_zones               = var.systemnodes_zones
    systemnode_count                = var.systemnode_count
    systemnode_vm_size              = var.systemnode_vm_size
    systemnode_subnet_id            = local.systemnode_subnet_id
    usernode_subnet_id              = local.usernode_subnet_id
    usernode_zones                  = var.usernode_zones
    usernode_min_count              = var.usernode_min_count
    usernode_vm_size                = var.usernode_vm_size
    usernode_poolname               = var.usernode_poolname
    usernode_max_count              = var.usernode_max_count
    identity                        = var.identity
    admin_group_members             = var.admin_group_members
    network_plugin                  = var.network_plugin
    load_balancer_sku               = var.load_balancer_sku
    resource_group_name             = data.azurerm_resource_group.resource_group.name
    resource_group_id               = data.azurerm_resource_group.resource_group.id
    location                        = data.azurerm_resource_group.resource_group.location
    log_analytics_workspace_id      = data.azurerm_log_analytics_workspace.this.id
    application_code                = var.application_code
    resource_provider               = var.resource_provider  
    kubernetes_configuration        = var.kubernetes_configuration
    azure_container_registry_id     = module.azure-container-registry.id
    depends_on = [ module.azure-container-registry, module.nat_gateway ]
}

module "azure-bastion" {
  source = "../../../modules/azure/azure-bastion"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location = data.azurerm_resource_group.resource_group.location
  azurerm_public_ip_name = var.azurerm_public_ip_name
  azurerm_bastion_host_name = var.azurerm_bastion_host_name
  azurerm_bastion_host_ip_configuration_subnet_id = local.bastion_id
}

# module "azure-managed-prometheus" {
#   source = "../../../modules/azure/azure-managed-prometheus"
#   resource_group_name = data.azurerm_resource_group.resource_group.name
#   location = data.azurerm_resource_group.resource_group.location
#   application_code = var.application_code
#   azurerm_monitor_workspace_name = var.azurerm_monitor_workspace_name
#   azure_kubernetes_service_name = module.azure-kubernetes-service.cluster_name
#   azure_kubernetes_service_id = module.azure-kubernetes-service.cluster_id
# }

# module "azure-managed-grafana" {
#   source = "../../../modules/azure/azure-managed-grafana"
#   resource_group_name = data.azurerm_resource_group.resource_group.name
#   location = data.azurerm_resource_group.resource_group.location
#   azure_monitor_workspace_id = module.azure-managed-prometheus.azurerm_monitor_workspace_id
#   admin_group_members = var.admin_group_members
#   # application_code = var.application_code
#   azurerm_dashboard_grafana_name = var.azurerm_dashboard_grafana_name

# }