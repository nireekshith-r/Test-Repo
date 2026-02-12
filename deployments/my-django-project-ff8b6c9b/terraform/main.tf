terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.74"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "my_django_app_rg" {
  name     = "${var.app_name}-rg"
  location = var.region

  tags = var.tags
}

# Virtual Network
resource "azurerm_virtual_network" "my_django_app_vnet" {
  name                = "${var.app_name}-vnet"
  location            = azurerm_resource_group.my_django_app_rg.location
  resource_group_name = azurerm_resource_group.my_django_app_rg.name
  address_space       = ["10.0.0.0/16"]

  tags = var.tags
}

# Subnet
resource "azurerm_subnet" "my_django_app_subnet" {
  name                 = "${var.app_name}-subnet"
  resource_group_name  = azurerm_resource_group.my_django_app_rg.name
  virtual_network_name = azurerm_virtual_network.my_django_app_vnet.name
  address_prefixes     = ["10.0.1.0/24"]

  tags = var.tags
}

# AKS Cluster
resource "azurerm_kubernetes_cluster" "my_django_app_aks" {
  name                = "${var.app_name}-aks"
  location            = azurerm_resource_group.my_django_app_rg.location
  resource_group_name = azurerm_resource_group.my_django_app_rg.name
  dns_prefix          = "${var.app_name}-dns"

  default_node_pool {
    name       = "default"
    node_count = var.replicas
    vm_size    = "Standard_DS2_v2"

    tags = var.tags
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Azure Container Registry
resource "azurerm_container_registry" "my_django_app_acr" {
  name                = "${var.app_name}acr"
  location            = azurerm_resource_group.my_django_app_rg.location
  resource_group_name = azurerm_resource_group.my_django_app_rg.name
  sku                 = "Standard"

  tags = var.tags
}