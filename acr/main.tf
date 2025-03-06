# Locals for conditional logic
locals {
  sku_is_premium   = lower(var.sku) == "premium"
  sku_is_standard  = lower(var.sku) == "standard"
  sku_is_basic     = lower(var.sku) == "basic"
  apply_georeplica = local.sku_is_premium && length(var.georeplications) > 0
  apply_network_rs = local.sku_is_premium && var.network_rule_set != null
  apply_encryption = var.encryption != null
  apply_identity   = var.identity != null
}

# Azure Container Registry (ACR)
resource "azurerm_container_registry" "acr" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = var.admin_enabled

  # Only set these Premium-only settings if the SKU is Premium
  quarantine_policy_enabled = local.sku_is_premium ? var.quarantine_policy_enabled : null
  retention_policy_in_days  = local.sku_is_premium ? var.retention_policy_in_days : null
  trust_policy_enabled      = local.sku_is_premium ? var.trust_policy_enabled : null
  zone_redundancy_enabled   = local.sku_is_premium ? var.zone_redundancy_enabled : null
  export_policy_enabled     = local.sku_is_premium ? var.export_policy_enabled : null

  # For Standard or Premium SKUs
  anonymous_pull_enabled = (local.sku_is_standard || local.sku_is_premium) ? var.anonymous_pull_enabled : null

  # For Premium only
  data_endpoint_enabled      = local.sku_is_premium ? var.data_endpoint_enabled : null
  network_rule_bypass_option = var.network_rule_bypass_option

  public_network_access_enabled = var.public_network_access_enabled

  # Optional: If georeplications is not empty, build dynamic blocks (Premium only)
  dynamic "georeplications" {
    for_each = local.apply_georeplica ? var.georeplications : []
    content {
      location                  = georeplications.value.location
      regional_endpoint_enabled = lookup(georeplications.value, "regional_endpoint_enabled", null)
      zone_redundancy_enabled   = lookup(georeplications.value, "zone_redundancy_enabled", false)
      tags                      = lookup(georeplications.value, "tags", {})
    }
  }

  # network_rule_set (Premium only)
  dynamic "network_rule_set" {
    for_each = local.apply_network_rs ? [var.network_rule_set] : []
    content {
      default_action = network_rule_set.value.default_action

      dynamic "ip_rule" {
        for_each = network_rule_set.value.ip_rules
        content {
          action   = ip_rule.value.action
          ip_range = ip_rule.value.ip_range
        }
      }
    }
  }

  # identity block (SystemAssigned, UserAssigned, or both)
  dynamic "identity" {
    for_each = local.apply_identity ? [var.identity] : []
    content {
      type         = identity.value.type
      identity_ids = lookup(identity.value, "identity_ids", null)
    }
  }

  # encryption block
  dynamic "encryption" {
    for_each = local.apply_encryption ? [var.encryption] : []
    content {
      key_vault_key_id   = encryption.value.key_vault_key_id
      identity_client_id = encryption.value.identity_client_id
    }
  }

  tags = var.tags
}

/*
CACHE RULES
*/
resource "azurerm_container_registry_cache_rule" "cache_rules" {
  for_each = { for rule in var.cache_rules : rule.name => rule }

  name                  = each.value.name
  container_registry_id = azurerm_container_registry.acr.id
  source_repo           = each.value.source_repo
  target_repo           = each.value.target_repo
  credential_set_id     = lookup(each.value, "credential_set_id", null)
}
