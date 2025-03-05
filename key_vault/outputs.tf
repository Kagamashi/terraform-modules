output "id" {
  description = "The ID of the Key Vault."
  value       = azurerm_key_vault.this.id
}

output "vault_uri" {
  description = "The URI of the Key Vault (e.g., https://mykeyvault.vault.azure.net/)."
  value       = azurerm_key_vault.this.vault_uri
}
