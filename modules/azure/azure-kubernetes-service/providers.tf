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
      version = ">=2.25.2"
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