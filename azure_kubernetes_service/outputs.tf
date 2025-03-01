##########
# OUTPUTS.TF
##########
output "kube_config" {
  description = "Kubeconfig to access the AKS cluster."
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
}

output "client_certificate" {
  description = "Client certificate for the AKS cluster."
  value       = azurerm_kubernetes_cluster.aks.kube_admin_config.0.client_certificate
  sensitive   = true
}

output "client_key" {
  description = "Client key for the AKS cluster."
  value       = azurerm_kubernetes_cluster.aks.kube_admin_config.0.client_key
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "Cluster CA certificate for the AKS cluster."
  value       = azurerm_kubernetes_cluster.aks.kube_admin_config.0.cluster_ca_certificate
  sensitive   = true
}

output "cluster_endpoint" {
  description = "Endpoint for the AKS cluster."
  value       = azurerm_kubernetes_cluster.aks.kube_admin_config.0.host
}

output "node_resource_group" {
  description = "The resource group where AKS-managed resources are created."
  value       = azurerm_kubernetes_cluster.aks.node_resource_group
}

output "identity_principal_id" {
  description = "The principal ID of the system-assigned managed identity."
  value       = azurerm_kubernetes_cluster.aks.identity.0.principal_id
}

output "aks_id" {
  description = "The ID of the AKS cluster."
  value       = azurerm_kubernetes_cluster.aks.id
}

output "aks_fqdn" {
  description = "The FQDN of the AKS cluster."
  value       = azurerm_kubernetes_cluster.aks.fqdn
}

output "private_fqdn" {
  description = "The private FQDN of the AKS cluster (if private cluster is enabled)."
  value       = azurerm_kubernetes_cluster.aks.private_fqdn
}
