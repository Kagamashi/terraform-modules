##########
# MAIN.TF
##########
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  kubernetes_version      = var.kubernetes_version
  private_cluster_enabled = var.private_cluster_enabled
  sku_tier                = var.sku_tier

  default_node_pool {
    name                = "default"
    node_count          = var.node_count
    vm_size             = var.vm_size
    os_disk_size_gb     = var.os_disk_size_gb
    enable_auto_scaling = var.enable_auto_scaling
    min_count           = var.min_node_count
    max_count           = var.max_node_count
    vnet_subnet_id      = var.subnet_id
    type                = var.node_pool_type
    max_pods            = var.max_pods
    zones               = var.node_zones
  }

  identity {
    type = var.identity_type
  }

  network_profile {
    network_plugin    = var.network_plugin
    network_policy    = var.network_policy
    load_balancer_sku = "standard"
    outbound_type     = var.outbound_type
    pod_cidr          = var.pod_cidr
    service_cidr      = var.service_cidr
    dns_service_ip    = var.dns_service_ip
  }

  oms_agent {
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }

  auto_scaler_profile {
    expander                     = var.auto_scaler_expander
    balance_similar_node_groups  = var.balance_similar_node_groups
    max_graceful_termination_sec = var.max_graceful_termination_sec
    scale_down_delay_after_add   = var.scale_down_delay_after_add
    scale_down_unneeded          = var.scale_down_unneeded
    scale_down_unready           = var.scale_down_unready
    scan_interval                = var.scan_interval
  }

  tags = var.tags
}
