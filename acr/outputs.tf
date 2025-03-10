output "acr" {
  value     = azurerm_container_registry.acr
  sensitive = true
}

output "id" {
  description = "The ID of the Container Registry."
  value       = azurerm_container_registry.acr.id
}

output "login_server" {
  description = "The login server URL to authenticate/pull images from acr Container Registry."
  value       = azurerm_container_registry.acr.login_server
}

output "admin_username" {
  description = "The admin username for the Container Registry (if admin is enabled)."
  value       = azurerm_container_registry.acr.admin_username
  # Mark as sensitive if you prefer:
  // sensitive    = true
}

output "admin_password" {
  description = "The admin password for the Container Registry (if admin is enabled)."
  value       = azurerm_container_registry.acr.admin_password
  sensitive   = true
}

# Identity block details (if MSI is enabled)
output "identity_principal_id" {
  description = "Principal ID for the MSI if the Container Registry has an identity."
  value       = azurerm_container_registry.acr.identity[0].principal_id
  depends_on  = [azurerm_container_registry.acr]
}

output "identity_tenant_id" {
  description = "Tenant ID for the MSI if the Container Registry has an identity."
  value       = azurerm_container_registry.acr.identity[0].tenant_id
  depends_on  = [azurerm_container_registry.acr]
}

/*
CACHE RULES
*/
output "cache_rule_ids" {
  description = "Map of all created cache rule IDs, keyed by rule name."
  value = {
    for rule_key, rule_resource in azurerm_container_registry_cache_rule.cache_rules :
    rule_key => rule_resource.id
  }
}
