output "akv" {
  value     = azurerm_key_vault.akv
  sensitive = true
}

output "id" {
  description = "The ID of the Key Vault."
  value       = azurerm_key_vault.akv.id
}

output "vault_uri" {
  description = "The URI of the Key Vault (e.g., https://mykeyvault.vault.azure.net/)."
  value       = azurerm_key_vault.akv.vault_uri
}
