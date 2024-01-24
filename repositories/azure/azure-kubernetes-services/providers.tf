terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.75.0"
      }
    azapi = {
      source = "Azure/azapi"
      version = ">=1.9.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.25.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.12.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
    # backend "azurerm" {}
  }
provider "azurerm" {
  features {
    resource_group {
    prevent_deletion_if_contains_resources = false
    }
  }
  skip_provider_registration = false
  }
provider "kubernetes" {
        host                   = module.azure-kubernetes-service.cluster_hostnames
        client_certificate     = base64decode(module.azure-kubernetes-service.cluster_client_certificate)
        client_key             = base64decode(module.azure-kubernetes-service.cluster_client_key)
        cluster_ca_certificate = base64decode(module.azure-kubernetes-service.cluster_ca_certificate)
}
provider "helm" {
  kubernetes {
        host                   = module.azure-kubernetes-service.cluster_hostnames
        client_certificate     = base64decode(module.azure-kubernetes-service.cluster_client_certificate)
        client_key             = base64decode(module.azure-kubernetes-service.cluster_client_key)
        cluster_ca_certificate = base64decode(module.azure-kubernetes-service.cluster_ca_certificate)
  }
}

provider "kubectl" {
  host = module.azure-kubernetes-service.cluster_hostnames
  client_certificate     = base64decode(module.azure-kubernetes-service.cluster_client_certificate)
  client_key             = base64decode(module.azure-kubernetes-service.cluster_client_key)
  cluster_ca_certificate = base64decode(module.azure-kubernetes-service.cluster_ca_certificate)
}