# Azure Kubernetes Private Cluster Baseline
### Iniciamos clonando el repositorio
```bash
git clone https://github.com/iesussan/terraform-cicd-framework
```
### El repositorio contiene la siguiente estructura:
```bash
├── LICENSE
├── README.md
├── modules
│   └── azure
│       ├── azure-bastion 
│       │   ├── main.tf
│       │   ├── outputs.tf
│       │   └── variables.tf
│       ├── azure-container-registry
│       │   ├── main.tf
│       │   ├── outputs.tf
│       │   └── variables.tf
│       ├── azure-entraid-groups-management
│       │   ├── main.tf
│       │   ├── outputs.tf
│       │   ├── providers.tf
│       │   └── variables.tf
│       ├── azure-kubernetes-service
│       │   ├── configuration
│       │   │   ├── ama-metrics-prometheus-config-configmap.yaml
│       │   │   ├── ama-metrics-settings-configmap.yaml
│       │   │   └── kube-prometheus-stack-custom-values.yaml
│       │   ├── main.tf
│       │   ├── outputs.tf
│       │   ├── providers.tf
│       │   └── variables.tf
│       ├── azure-log-analytics-workspace
│       │   ├── main.tf
│       │   ├── outputs.tf
│       │   └── variables.tf
│       ├── azure-nat-gateway
│       │   ├── main.tf
│       │   ├── output.tf
│       │   └── variables.tf
│       ├── azure-networking
│       │   ├── main.tf
│       │   ├── outputs.tf
│       │   ├── providers.tf
│       │   └── variables.tf
│       ├── azure-private-dns-zone
│       │   ├── main.tf
│       │   ├── outputs.tf
│       │   └── variables.tf
│       ├── azure-private-endpoint
│       │   ├── main.tf
│       │   ├── outputs.tf
│       │   └── variables.tf
│       └── azure-resource-group
│           ├── README.md
│           ├── main.tf
│           ├── outputs.tf
│           └── variables.tf
├── repositories
│   └── azure
│       ├── azure-kubernetes-services
│       │   ├── environment
│       │   │   ├── dev
│       │   │   │   └── auto.tfvars
│       │   │   ├── prd
│       │   │   │   └── auto.tfvars
│       │   │   └── stg
│       │   │       └── auto.tfvars
│       │   ├── main.tf
│       │   ├── outputs.tf
│       │   ├── pod-oidc.yaml
│       │   ├── providers.tf
│       │   ├── terraform.tfstate
│       │   ├── terraform.tfstate.backup
│       │   └── variables.tf
│       └── azure-subscription-baseline
│           ├── environment
│           │   ├── dev
│           │   │   └── dev.auto.tfvars
│           │   ├── prd
│           │   │   └── prd.auto.tfvars
│           │   └── stg
│           │       └── stg.auto.tfvars
│           ├── main.tf
│           ├── provider.tf
│           └── variables.tf
```
### El directorio **modules** contiene todas las piezas de codigo de reutilizable de codigo terraform seperados segun su responsabilidad, en este caso divido por servicio de azure correspondiente.

### El directorio **repositories** contiene ejemplos de como orquestar los modulos de terraform correspondientes, incluyendo la segregación de variables por ambientes. Los ejemplos contienen 3 ambientes. 

### Para dar vida por a un cluster de Azure Kubernetes services debemos seguir los siguientes pasos:

```bash
cd repositories/azure/azure-subscription-baseline/
```
### Este directorio contiene un ejemplo de orquestacion para una suscripción naciente. Tiene la siguiente estructura:

```bash
├── environment
│   ├── dev
│   │   └── auto.tfvars
│   ├── prd
│   │   └── auto.tfvars
│   └── stg
│       └── auto.tfvars
├── main.tf
├── provider.tf
└── variables.tf
```
### El directorio **environment** contiene todas las variables de enternos que se reemplazaran en los modulos correspondientes que se orquestaran.

### El archivo **main.tf** contiene la declaracion de los modulos.

```shell
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
```
### El archivo **provider.tf** contiene la declaracion de los providers usados para el despliegue.
```shell
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.75.0"
      }
    azapi = {
      source = "Azure/azapi"
      version = ">= 1.9.0"
    }
  }
    # backend "azurerm" {}
  }
provider "azurerm" {
  features {}
  skip_provider_registration = false
  }
provider "azapi" {
}
```
### El archivo **variables.tf** sirve para declarar las variables que van a ser sustituidas en los archivos de environment correspondientes.

### Para dar vida al demo se requiere exportar las siguientes variables:

```bash
#Variable que permitira gestionar el entorno que deseamos aprovisionar
export ENVIRONMENT='dev'
#Variables que nos permitiran autenticarnos con azure
export ARM_CLIENT_ID=""
export ARM_CLIENT_SECRET=""
export ARM_TENANT_ID=""
export ARM_SUBSCRIPTION_ID=""
```
### Ahora ejecutamos los comando de terraform correspondientes
```bash
terraform init
terraform plan -var-file="./environment/${ENVIRONMENT}/auto.tfvars"
terraform apply -auto-approve -var-file="./environment/${ENVIRONMENT}/auto.tfvars"
```
### Con estamos pasos se habra creado el Azure Resource Group correspondiente al ambiente y un azure log analytics workspace

### Ahora para aprovisionar el cluster de azure kubernetes service seguiremos los siguientes pasos:
```bash
 cd ../azure-kubernetes-services
```
### Como nos encontramos en el mismo entorno de bash ya no es necesario volver a exportar las variables.
```bash
├── environment
│   ├── dev
│   │   └── auto.tfvars
│   ├── prd
│   │   └── auto.tfvars
│   └── stg
│       └── auto.tfvars
├── main.tf
├── outputs.tf
├── providers.tf
└── variables.tf
```

### Como Podemos notar el directorio cuenta con la misma estructura que el anterior ejemplo de orquestacion de modulos llamada "azure-subscription-baseline". Este sera nuestro nuevo estandar de ejecución. Si deseamos agregar / modificar los valores de las variables de los servicios en el directorio de environment.
```bash
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
```
### Ahora ejecutamos los comando de terraform correspondientes
```bash
terraform init
terraform plan -var-file="./environment/${ENVIRONMENT}/auto.tfvars"
terraform apply -auto-approve -var-file="./environment/${ENVIRONMENT}/auto.tfvars"
```