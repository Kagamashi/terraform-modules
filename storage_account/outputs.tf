output "sa" {
  value     = azurerm_storage_account.sa
  sensitive = true
}

output "id" {
  description = "The ID of the Storage Account."
  value       = azurerm_storage_account.sa.id
}

output "primary_location" {
  description = "The primary location of the storage account."
  value       = azurerm_storage_account.sa.primary_location
}

output "primary_access_key" {
  description = "The primary access key for sa storage account."
  value       = azurerm_storage_account.sa.primary_access_key
  sensitive   = true
}

output "secondary_access_key" {
  description = "The secondary access key for sa storage account."
  value       = azurerm_storage_account.sa.secondary_access_key
  sensitive   = true
}

output "primary_connection_string" {
  description = "The primary connection string for sa storage account."
  value       = azurerm_storage_account.sa.primary_connection_string
  sensitive   = true
}
