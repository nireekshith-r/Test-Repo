output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.my_django_app_rg.name
}

output "aks_cluster_name" {
  description = "Name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.my_django_app_aks.name
}

output "acr_name" {
  description = "Name of the Azure Container Registry"
  value       = azurerm_container_registry.my_django_app_acr.name
}

output "aks_cluster_endpoint" {
  description = "AKS cluster API endpoint"
  value       = azurerm_kubernetes_cluster.my_django_app_aks.kube_config.0.host
}