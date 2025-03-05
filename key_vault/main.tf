##########################
# Local condition checks #
##########################
locals {
  use_network_acls = var.network_acls != null
}

#################################
# Azure Key Vault Resource
#################################
resource "azurerm_key_vault" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id
  sku_name            = var.sku_name

  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  enable_rbac_authorization       = var.enable_rbac_authorization

  soft_delete_retention_days = var.soft_delete_retention_days
  purge_protection_enabled   = var.purge_protection_enabled

  public_network_access_enabled = var.public_network_access_enabled

  # If network_acls is not null, define it
  dynamic "network_acls" {
    for_each = local.use_network_acls ? [var.network_acls] : []
    content {
      bypass         = lookup(network_acls.value, "bypass", null)
      default_action = lookup(network_acls.value, "default_action", null)

      ip_rules                   = lookup(network_acls.value, "ip_rules", [])
      virtual_network_subnet_ids = lookup(network_acls.value, "virtual_network_subnet_ids", [])
    }
  }

  # Inline access policies
  dynamic "access_policy" {
    for_each = { for p in var.access_policies : p.object_id => p }
    content {
      tenant_id = access_policy.value.tenant_id
      object_id = access_policy.value.object_id

      application_id = lookup(access_policy.value, "application_id", null)

      key_permissions         = lookup(access_policy.value, "key_permissions", [])
      secret_permissions      = lookup(access_policy.value, "secret_permissions", [])
      storage_permissions     = lookup(access_policy.value, "storage_permissions", [])
      certificate_permissions = lookup(access_policy.value, "certificate_permissions", [])
    }
  }

  tags = var.tags
}
