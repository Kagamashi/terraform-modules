# Local condition checks #
locals {
  use_identity          = var.identity != null
  identity_is_user      = local.use_identity && lower(var.identity.type) == "userassigned"
  identity_is_system    = local.use_identity && lower(var.identity.type) == "systemassigned"
  use_network_profile   = var.network_profile != null
  private_cluster_logic = var.private_cluster_enabled ? true : false
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  # If user doesn't supply a dns_prefix, and it's a public cluster, Azure auto-generates one.
  # For a private cluster, you do need to specify either dns_prefix or dns_prefix_private_cluster,
  # but we can do some logic here. We'll pass dns_prefix if provided.
  dns_prefix = var.dns_prefix

  kubernetes_version = var.kubernetes_version
  sku_tier           = var.sku_tier

  # Private cluster config
  private_cluster_enabled = var.private_cluster_enabled

  # If user supplies private_dns_zone_id and private cluster is enabled
  private_dns_zone_id = var.private_cluster_enabled ? var.private_dns_zone_id : null

  # Node Resource Group. If you want a custom node RG, define it here:
  # node_resource_group = "my-custom-noderesourcegroup"

  # RBAC
  role_based_access_control_enabled = var.role_based_access_control_enabled

  # Azure AD -> azure_rbac_enabled
  dynamic "azure_active_directory_role_based_access_control" {
    for_each = var.azure_rbac_enabled ? [true] : []
    content {
      tenant_id              = null
      azure_rbac_enabled     = var.azure_rbac_enabled
      admin_group_object_ids = var.aad_admin_group_object_ids
    }
  }

  # HTTP Application Routing
  http_application_routing_enabled = var.http_application_routing_enabled

  # Identity
  dynamic "identity" {
    for_each = local.use_identity ? [var.identity] : []
    content {
      type         = identity.value.type
      identity_ids = lookup(identity.value, "identity_ids", null)
    }
  }

  # Network profile (optional)
  dynamic "network_profile" {
    for_each = local.use_network_profile ? [var.network_profile] : []
    content {
      network_plugin    = lookup(network_profile.value, "network_plugin", null)
      network_policy    = lookup(network_profile.value, "network_policy", null)
      load_balancer_sku = lookup(network_profile.value, "load_balancer_sku", "standard")
      outbound_type     = lookup(network_profile.value, "outbound_type", "loadBalancer")
      service_cidr      = lookup(network_profile.value, "service_cidr", null)
      dns_service_ip    = lookup(network_profile.value, "dns_service_ip", null)
      pod_cidr          = lookup(network_profile.value, "pod_cidr", null)
    }
  }

  #################################
  # Default Node Pool (required)  #
  #################################
  default_node_pool {
    name            = var.default_node_pool.name
    vm_size         = var.default_node_pool.vm_size
    node_count      = var.default_node_pool.node_count
    os_disk_size_gb = var.default_node_pool.os_disk_size_gb
    os_disk_type    = var.default_node_pool.os_disk_type
    vnet_subnet_id  = var.default_node_pool.vnet_subnet_id
    max_pods        = var.default_node_pool.max_pods

    # If availability_zones is non-empty, set it
    zones = var.default_node_pool.availability_zones != null ? var.default_node_pool.availability_zones : []

    # Auto-scaling
    auto_scaling_enabled = lookup(var.default_node_pool, "auto_scaling", false)
    min_count            = var.default_node_pool.auto_scaling ? lookup(var.default_node_pool, "min_count", null) : null
    max_count            = var.default_node_pool.auto_scaling ? lookup(var.default_node_pool, "max_count", null) : null
  }

  tags = var.tags
}
