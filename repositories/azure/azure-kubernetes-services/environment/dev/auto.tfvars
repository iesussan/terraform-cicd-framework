#================================== AZURE AKS PRE-REQUISITES VARIABLES  ============================
resource_group_name        = "RSGREU2IESUSDEV01"
virtual_network_name          = "AZVN-AKS-EU2-IESUSINTEGRATION-DEV-01"
virtual_network_address_space = ["172.48.0.0/21"]
virtual_network_subnets       = [
  {
    name           = "AZVN-AKS-SUBNET-SYSTEMNODES-EU2-IESUSINTEGRATION-DEV-01"
    address_prefix = "172.48.0.0/24"
  },
  {
    name           = "AZVN-AKS-SUBNET-USERNODES-EU2-IESUSINTEGRATION-DEV-01"
    address_prefix = "172.48.1.0/24"
  },
  {
    name           = "AZVN-AKS-SUBNET-APISERVER-EU2-IESUSINTEGRATION-DEV-01"
    address_prefix = "172.48.2.0/24"
  },
  {
    name           = "AzureBastionSubnet"
    address_prefix = "172.48.3.0/27"
  },
  {
    name           = "AZVN-SUBNET-JUMPSERVER-EU2-IESUSINTEGRATION-DEV-01"
    address_prefix = "172.48.3.32/27"
  },
  {
    name           = "AZVN-SUBNET-PE-EU2-IESUSINTEGRATION-DEV-01"
    address_prefix = "172.48.4.0/27"
  },
  {
    name           = "AZVN-SUBNET-NATGATEWAY-EU2-IESUSINTEGRATION-DEV-01"
    address_prefix = "172.48.4.32/27"

  }
]
service_endpoints=[] 
tags        = {
  environment = "dev"
  project     = "integration"
  owner       = "iesus"
}
#users = ["jesussan_microsoft.com#EXT#@fdpo.onmicrosoft.com"]

#==================================AZURE KEYVAULT VARIABLES OVERWRITE ==============================
keyvault_name                 = "RSGREU2KVIESUSDEV001"  
enabled_for_disk_encryption   = true
soft_delete_retention_days    = 7
purge_protection_enabled      = false
keyvault_sku_name             = "standard"

#==================================ACR VARIABLES OVERWRITE ==============================
container_registry_name       = "RSGREU2ACRIESUSDEV01"
acr_sku="Premium"
#================================== AZURE AKS VARIABLES OVERWRITE ==================================
kubernetes_service_name       = "AKS-EU2-IESUSINTEGRATION-DEV-01"
kubernetes_version            = "1.28.3"
systemnode_poolname           = "iesussndev"    
systemnodes_zones             = ["2"]    
systemnode_count              = 2
systemnode_vm_size            = "Standard_D2a_v4"
usernode_poolname             = "iesusundev"
usernode_zones                = ["3"]
usernode_min_count            = 2
usernode_vm_size              = "Standard_D2a_v4"
usernode_max_count            = 2
identity                      = "SystemAssigned"
network_plugin                = "azure"    
load_balancer_sku             = "standard"
admin_group_members           = "iesus-aks-users-administrators"
log_analytics_workspace_name  = "RSGREU2LAWIESUSDEV01"
application_code              = "iesus"
resource_provider             = {
  kubernetes                  = "Microsoft.Kubernetes"
  # ContainerService          = "Microsoft.ContainerService"
  KubernetesConfiguration     = "Microsoft.KubernetesConfiguration"
  }
kubernetes_configuration      = {
  namespaces = [
    {name = "iesus"},
    {name = "ingress-nginx"}
  ]
}
azurerm_monitor_workspace_name = "U2LAWIESUSDEV01"
azurerm_dashboard_grafana_name = "U2GRAFANAIESUSDEV01"
#================================== AZURE BASTION CONFIGURATION ==================================
azurerm_bastion_host_name      = "AZBASTION-EU2-IESUSINTEGRATION-DEV-01"
azurerm_public_ip_name         = "AZPIP-EU2-IESUSINTEGRATION-DEV-01"
#================================== AZURE NAT GATEWAT CONFIGURATION ==================================
nat_gateway_name              = "NATGW-EU2-IESUSINTEGRATION-DEV-01"