# AKS Terraform Module

## Usage:

```hcl
module "aks" {
  source = "./modules/azure_kubernetes_service"

  name                = "my-aks-cluster"
  location            = "West Europe"
  resource_group_name = "rg-example"

  dns_prefix          = "myaks"        # or null if you'd like Azure to auto-generate

  kubernetes_version  = "1.26.3"
  sku_tier            = "Standard"

  private_cluster_enabled = false
  private_dns_zone_id     = null

  role_based_access_control_enabled = true
  azure_rbac_enabled               = false
  aad_admin_group_object_ids        = []

  http_application_routing_enabled = false

  network_profile = {
    network_plugin       = "azure"
    network_policy       = null
    load_balancer_sku    = "standard"
    outbound_type        = "loadBalancer"
    service_cidr         = "10.0.0.0/16"
    dns_service_ip       = "10.0.0.10"
    docker_bridge_cidr   = "172.17.0.1/16"
    pod_cidr             = null
  }

  default_node_pool = {
    name               = "default"
    vm_size            = "Standard_D2_v2"
    node_count         = 2
    auto_scaling       = true
    min_count          = 2
    max_count          = 5
    os_disk_size_gb    = 30
    os_disk_type       = "Managed"
    vnet_subnet_id     = null
    max_pods           = 110
    availability_zones = ["1", "2", "3"]
  }

  identity = {
    type         = "SystemAssigned"
    identity_ids = null
  }

  tags = {
    environment = "staging"
    costcenter  = "cc123"
  }
}
```

---

## Notes:

### Private Clusters

- If `private_cluster_enabled = true`, you should set `private_dns_zone_id` to either a private DNS zone resource ID, `"System"`, or `"None"`.
- Providing the private DNS zone ensures your cluster’s private endpoint is resolvable.

---

### Identity

- If you choose `type = "UserAssigned"`, specify `identity_ids = ["<resource_id_of_identity>"]`.
- When using user-assigned identity, ensure the identity has necessary permissions (e.g., on the subnet, etc.).

---

### RBAC & Azure AD

- By default, `role_based_access_control_enabled` is `true`.
- `azure_rbac_enabled` can be set to `true` to allow Azure RBAC for Kubernetes authorization.
- If you want to use Azure Active Directory integration with admin groups, specify the Object IDs in `aad_admin_group_object_ids`.

---

### Network Profile

- `network_plugin = "azure"` (Azure CNI) vs. `"kubenet"` is a key decision.
- For advanced networking with subnets, pass `vnet_subnet_id` in the `default_node_pool`.
- `load_balancer_sku` defaults to `standard`; consider `basic` only for test/dev scenarios.

---

### Node Pools

- This module only defines the **default (system) node pool**.
- For additional user node pools, you typically define extra `azurerm_kubernetes_cluster_node_pool` resources outside this module.

---

### Upgrades

- `kubernetes_version` can be updated as new versions become available.
- Upgrading node pool or cluster version is typically a safe operation but can take time.
- Auto-scaler toggles can be changed, but sometimes changes may disrupt running workloads if not planned.

---

### Outputs

- `kube_config_raw` and `kube_admin_config_raw` are marked **sensitive** and stored in Terraform state in plain text.
- Use them carefully, especially in CI/CD pipelines.

---

### Add-ons

- You can expand this module to enable other add-ons (OMS Agent, Azure Policy, etc.) by adding more input variables and dynamic blocks.
