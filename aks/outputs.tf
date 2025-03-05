output "id" {
  description = "The ID of the Azure Kubernetes Service cluster."
  value       = azurerm_kubernetes_cluster.this.id
}

output "name" {
  description = "The name of the AKS cluster."
  value       = azurerm_kubernetes_cluster.this.name
}

output "fqdn" {
  description = "The FQDN of the Azure Kubernetes Managed Cluster."
  value       = azurerm_kubernetes_cluster.this.fqdn
}

output "private_fqdn" {
  description = "The private FQDN if private cluster is enabled."
  value       = azurerm_kubernetes_cluster.this.private_fqdn
}

output "kube_config_raw" {
  description = "Raw Kubernetes config to be used by kubectl."
  value       = azurerm_kubernetes_cluster.this.kube_config_raw
  sensitive   = true
}

output "kube_admin_config_raw" {
  description = "Raw Kubernetes admin config. Only available if RBAC is enabled and local accounts enabled."
  value       = azurerm_kubernetes_cluster.this.kube_admin_config_raw
  sensitive   = true
}

output "oidc_issuer_url" {
  description = "The OIDC issuer URL for the cluster if OIDC integration is enabled."
  value       = azurerm_kubernetes_cluster.this.oidc_issuer_url
}

output "identity" {
  description = "Managed Service Identity block for the AKS cluster."
  value       = azurerm_kubernetes_cluster.this.identity
}
