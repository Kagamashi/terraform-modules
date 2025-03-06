##########################
# Local condition checks #
##########################
locals {
  enable_network_rules = var.network_rules != null && (
    var.network_rules.default_action != null ||
    length(var.network_rules.ip_rules) > 0 ||
    length(var.network_rules.virtual_network_subnet_ids) > 0
  )
}

#################################
# Azure Storage Account Resource
#################################
resource "azurerm_storage_account" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  account_kind             = var.account_kind
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type

  # optional properties
  cross_tenant_replication_enabled = var.cross_tenant_replication_enabled
  access_tier                      = var.access_tier
  https_traffic_only_enabled       = var.https_traffic_only_enabled
  min_tls_version                  = var.min_tls_version
  allow_nested_items_to_be_public  = var.allow_nested_items_to_be_public
  shared_access_key_enabled        = var.shared_access_key_enabled
  public_network_access_enabled    = var.public_network_access_enabled
  is_hns_enabled                   = var.is_hns_enabled
  sftp_enabled                     = var.sftp_enabled
  nfsv3_enabled                    = var.nfsv3_enabled

  # Only define network_rules if user provided them
  dynamic "network_rules" {
    for_each = local.enable_network_rules ? [var.network_rules] : []
    content {
      default_action             = lookup(network_rules.value, "default_action", "Allow")
      bypass                     = lookup(network_rules.value, "bypass", null)
      ip_rules                   = lookup(network_rules.value, "ip_rules", [])
      virtual_network_subnet_ids = lookup(network_rules.value, "virtual_network_subnet_ids", [])
    }
  }

  tags = var.tags
}
