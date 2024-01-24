
data "azurerm_client_config" "current" {}

module "azure-resource-group" {
    source        = "../../../modules/azure/azure-resource-group"
    group_name = var.group_name
    location = var.location
    tags = var.tags
}

module "azure-log-analytics-workspace" {
    source = "../../../modules/azure/azure-log-analytics-workspace"
    log_analytics_workspace_name = var.log_analytics_workspace_name
    location = module.azure-resource-group.location
    resource_group_name = module.azure-resource-group.name
    log_analytics_workspace_sku = var.log_analytics_workspace_sku
    log_analytics_workspace_retention_in_days = var.log_analytics_workspace_retention_in_days
}

module "azure-entraid-groups-management" {
    source = "../../../modules/azure/azure-entraid-groups-management"
    users = var.users
    application_code = var.application_code
}