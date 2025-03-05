##########
# VARIABLES.TF
##########
variable "cluster_name" {
  description = "The name of the AKS cluster."
  type        = string
}

variable "location" {
  description = "The Azure region where the AKS cluster will be deployed."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group containing the AKS cluster."
  type        = string
}

variable "dns_prefix" {
  description = "The DNS prefix for the AKS cluster."
  type        = string
}

variable "kubernetes_version" {
  description = "The Kubernetes version to use for the AKS cluster."
  type        = string
  default     = ""
}

variable "private_cluster_enabled" {
  description = "Enable private AKS cluster."
  type        = bool
  default     = false
}

variable "sku_tier" {
  description = "The SKU Tier of the AKS cluster."
  type        = string
  default     = "Free"
}

variable "node_count" {
  description = "The number of nodes in the default node pool."
  type        = number
  default     = 3
}

variable "vm_size" {
  description = "The size of the virtual machines in the node pool."
  type        = string
  default     = "Standard_D2s_v3"
}

variable "os_disk_size_gb" {
  description = "The OS disk size of the node pool in GB."
  type        = number
  default     = 30
}

variable "enable_auto_scaling" {
  description = "Enable auto-scaling for the default node pool."
  type        = bool
  default     = true
}

variable "min_node_count" {
  description = "The minimum node count when auto-scaling is enabled."
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "The maximum node count when auto-scaling is enabled."
  type        = number
  default     = 5
}

variable "subnet_id" {
  description = "The subnet ID for the AKS cluster."
  type        = string
  default     = ""
}

variable "node_pool_type" {
  description = "The type of node pool, either 'VirtualMachineScaleSets' or 'AvailabilitySet'."
  type        = string
  default     = "VirtualMachineScaleSets"
}

variable "max_pods" {
  description = "The maximum number of pods per node."
  type        = number
  default     = 110
}

variable "node_zones" {
  description = "The availability zones for the node pool."
  type        = list(string)
  default     = ["1", "2", "3"]
}

variable "identity_type" {
  description = "The identity type of the AKS cluster, either 'SystemAssigned' or 'UserAssigned'."
  type        = string
  default     = "SystemAssigned"
}

variable "network_plugin" {
  description = "The network plugin to use for the AKS cluster."
  type        = string
  default     = "azure"
  validation {
    condition     = contains(["azure", "kubenet"], var.network_plugin)
    error_message = "Valid values are 'azure' or 'kubenet'."
  }
}

variable "network_policy" {
  description = "The network policy to use for the AKS cluster."
  type        = string
  default     = "calico"
  validation {
    condition     = contains(["calico", "azure", "cilium"], var.network_policy)
    error_message = "Valid values are 'calico', 'azure', or 'cilium'."
  }
}

variable "outbound_type" {
  description = "The outbound type for AKS cluster networking."
  type        = string
  default     = "loadBalancer"
}

variable "pod_cidr" {
  description = "The CIDR range for the pods."
  type        = string
  default     = ""
}

variable "service_cidr" {
  description = "The CIDR range for the services."
  type        = string
  default     = ""
}

variable "dns_service_ip" {
  description = "The DNS service IP for the cluster."
  type        = string
  default     = ""
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace for monitoring."
  type        = string
  default     = ""
}

variable "auto_scaler_expander" {
  description = "The expander for the auto-scaler."
  type        = string
  default     = "random"
}

variable "balance_similar_node_groups" {
  description = "Balance similar node groups when scaling."
  type        = bool
  default     = false
}

variable "max_graceful_termination_sec" {
  description = "Maximum graceful termination time in seconds."
  type        = number
  default     = 600
}

variable "scale_down_delay_after_add" {
  description = "Delay before a newly added node is considered for scale-down."
  type        = string
  default     = "10m"
}

variable "scale_down_unneeded" {
  description = "Time before an unneeded node is considered for scale-down."
  type        = string
  default     = "10m"
}

variable "scale_down_unready" {
  description = "Time before an unready node is considered for scale-down."
  type        = string
  default     = "20m"
}

variable "scan_interval" {
  description = "The scan interval for the auto-scaler."
  type        = string
  default     = "10s"
}

variable "tags" {
  description = "A map of tags to apply to the resources."
  type        = map(string)
  default     = {}
}
