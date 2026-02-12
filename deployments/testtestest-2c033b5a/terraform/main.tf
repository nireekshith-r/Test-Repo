terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.74.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "asdasd_rg" {
  name     = "${var.app_name}-${var.environment}-rg"
  location = var.region

  tags = var.tags
}

# Virtual Network
resource "azurerm_virtual_network" "asdasd_vnet" {
  name                = "${var.app_name}-${var.environment}-vnet"
  location            = azurerm_resource_group.asdasd_rg.location
  resource_group_name = azurerm_resource_group.asdasd_rg.name
  address_space       = ["10.0.0.0/16"]

  tags = var.tags
}

# Subnet
resource "azurerm_subnet" "asdasd_subnet" {
  name                 = "${var.app_name}-${var.environment}-subnet"
  resource_group_name  = azurerm_resource_group.asdasd_rg.name
  virtual_network_name = azurerm_virtual_network.asdasd_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# AKS Cluster
resource "azurerm_kubernetes_cluster" "asdasd_aks" {
  name                = "${var.app_name}-${var.environment}-aks"
  location            = azurerm_resource_group.asdasd_rg.location
  resource_group_name = azurerm_resource_group.asdasd_rg.name
  dns_prefix          = "${var.app_name}-${var.environment}"

  default_node_pool {
    name       = "default"
    node_count = var.replicas
    vm_size    = "Standard_DS2_v2"

    node_labels = {
      environment = var.environment
    }
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
    dns_service_ip    = "10.0.2.10"
    service_cidr      = "10.0.2.0/24"
    docker_bridge_cidr = "172.17.0.1/16"
  }

  tags = var.tags
}

# Azure Container Registry
resource "azurerm_container_registry" "asdasd_acr" {
  name                = "${var.app_name}${var.environment}acr"
  resource_group_name = azurerm_resource_group.asdasd_rg.name
  location            = azurerm_resource_group.asdasd_rg.location
  sku                 = "Basic"
  admin_enabled       = false

  tags = var.tags
}