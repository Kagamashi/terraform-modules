variable "name" {
  type        = string
  description = "Specifies the name of the AKS cluster (must be unique)."
}

variable "location" {
  type        = string
  description = "Specifies the Azure location where the AKS cluster will be created."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group in which to create the AKS cluster."
}

variable "dns_prefix" {
  type        = string
  description = <<EOT
Optional DNS prefix for the cluster. Must begin and end with a letter or number,
contain only letters, numbers, and hyphens, and be 1-54 characters.
Changing aks forces a new resource to be created.
EOT
  default     = null
}

variable "kubernetes_version" {
  type        = string
  description = <<EOT
Version of Kubernetes to deploy (e.g. 1.25, 1.26.3, etc.).
If not specified, the latest recommended version is used.
EOT
  default     = null
}

variable "sku_tier" {
  type        = string
  description = <<EOT
The SKU Tier of the AKS cluster. Possible values: "Free", "Standard", "Premium".
Defaults to "Free".
EOT
  default     = "Free"
}

variable "private_cluster_enabled" {
  type        = bool
  description = <<EOT
Specifies whether aks AKS cluster should only have internal IP addresses for
the API server. Defaults to false. Changing aks forces a new resource to be created.
EOT
  default     = false
}

variable "private_dns_zone_id" {
  type        = string
  description = <<EOT
Specifies the ID of a Private DNS Zone, "System", or "None" to manage
a private AKS cluster. Only used when private_cluster_enabled = true.
EOT
  default     = null
}

variable "network_profile" {
  type = object({
    network_plugin     = optional(string, null) # e.g., "azure", "kubenet", or "none"
    network_policy     = optional(string, null) # e.g., "calico", "azure", "cilium"
    load_balancer_sku  = optional(string, "standard")
    outbound_type      = optional(string, "loadBalancer") # e.g. "loadBalancer", "userDefinedRouting", "managedNATGateway", "userAssignedNATGateway"
    service_cidr       = optional(string, null)
    dns_service_ip     = optional(string, null)
    docker_bridge_cidr = optional(string, null)
    pod_cidr           = optional(string, null)
  })
  description = <<EOT
An object describing the network profile configuration for the AKS cluster:
  - network_plugin ("azure", "kubenet", or "none")
  - network_policy ("calico", "azure", or "cilium")
  - load_balancer_sku ("standard" or "basic")
  - outbound_type ("loadBalancer", "userDefinedRouting", "managedNATGateway", or "userAssignedNATGateway")
  - service_cidr, dns_service_ip, docker_bridge_cidr, pod_cidr
Set to null or omit fields you don't need.
EOT
  default     = null
}

variable "default_node_pool" {
  type = object({
    name               = string
    vm_size            = string
    node_count         = number
    auto_scaling       = optional(bool, false)
    min_count          = optional(number, null)
    max_count          = optional(number, null)
    os_disk_size_gb    = optional(number, null)
    os_disk_type       = optional(string, "Managed") # "Ephemeral", "Managed"
    vnet_subnet_id     = optional(string, null)      # For advanced networking
    max_pods           = optional(number, null)
    availability_zones = optional(list(string), null) # e.g. ["1","2","3"]
  })
  description = <<EOT
Configuration for the default (system) node pool.
  - name: Node pool name (required).
  - vm_size: Azure VM size (required).
  - node_count: number of nodes (required).
  - auto_scaling: should auto scaler be enabled?
  - min_count, max_count: used only if auto_scaling = true.
  - os_disk_size_gb, os_disk_type: disk config for each node.
  - vnet_subnet_id: subnet ID if using advanced networking (azure CNI).
  - max_pods: maximum pods per node.
  - availability_zones: List of zones for zone redundancy.
EOT
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = optional(list(string), null)
  })
  description = <<EOT
An identity block for the AKS cluster.
  - type can be "SystemAssigned" or "UserAssigned".
  - identity_ids is required only if type = "UserAssigned".
EOT
  default     = null
}

variable "role_based_access_control_enabled" {
  type        = bool
  description = "Specifies if Role Based Access Control (RBAC) is enabled. Defaults to true."
  default     = true
}

variable "azure_rbac_enabled" {
  type        = bool
  description = "Specifies if Azure RBAC for Kubernetes authorization is enabled."
  default     = false
}

variable "aad_admin_group_object_ids" {
  type        = list(string)
  description = <<EOT
A list of Azure AD group Object IDs that should have cluster admin role.
Only used if azure_rbac_enabled = true or for AAD integration.
EOT
  default     = []
}

variable "http_application_routing_enabled" {
  type        = bool
  description = "Specifies whether the HTTP Application Routing addon is enabled."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
  default     = {}
}
