variable "name" {
  type        = string
  description = "Specifies the name of the Container Registry (must be globally unique)."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where this Container Registry will be created."
}

variable "location" {
  type        = string
  description = "The Azure location where the Container Registry will be created."
}

variable "sku" {
  type        = string
  description = <<EOT
The SKU of the Container Registry. Possible values: "Basic", "Standard", "Premium".
- Many advanced features require "Premium".
EOT
  default     = "Basic"
}

variable "admin_enabled" {
  type        = bool
  description = "Specifies whether the admin user is enabled. Defaults to false."
  default     = false
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Whether public network access is allowed for the container registry."
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the Container Registry."
  default     = {}
}

variable "georeplications" {
  type = list(object({
    location                 = string
    regional_endpoint_enabled = optional(bool, null)
    zone_redundancy_enabled  = optional(bool, false)
    tags                     = optional(map(string), {})
  }))
  description = <<EOT
A list of geo-replication definitions (Premium SKU only).
Each element must be an object with:
  - location (string) (required)
  - regional_endpoint_enabled (bool) (optional)
  - zone_redundancy_enabled (bool) (optional)
  - tags (map of string) (optional)

**IMPORTANT**: The list of georeplications cannot include the main registry location,
and if multiple replications are provided, they should be sorted by location alphabetically.
EOT
  default = []
}

variable "quarantine_policy_enabled" {
  type        = bool
  description = "(Premium only) Boolean to enable the quarantine policy."
  default     = false
}

variable "retention_policy_in_days" {
  type        = number
  description = "(Premium only) Number of days to retain untagged manifests. Defaults to 7."
  default     = 7
}

variable "trust_policy_enabled" {
  type        = bool
  description = "(Premium only) Whether to enable the content trust policy."
  default     = false
}

variable "zone_redundancy_enabled" {
  type        = bool
  description = "(Premium only) Whether zone redundancy is enabled for the Container Registry itself."
  default     = false
}

variable "export_policy_enabled" {
  type        = bool
  description = <<EOT
(Premium only) Whether export policy is enabled. Defaults to true. 
In order to set false, public_network_access_enabled must also be false.
EOT
  default     = true
}

variable "network_rule_set" {
  type = object({
    default_action = string
    ip_rules = list(object({
      action   = string
      ip_range = string
    }))
  })

  description = <<EOT
(Premium only) A network_rule_set object with:
  - default_action: "Allow" or "Deny" (defaults to "Allow")
  - ip_rules: a list of objects with the properties:
      - action (only "Allow" is supported)
      - ip_range (CIDR to allow)
  
If this variable is null or not set, no network_rule_set will be applied.
EOT

  default = null
}

variable "network_rule_bypass_option" {
  type        = string
  description = <<EOT
Specifies how trusted Azure services access a network-restricted ACR.
Valid values are "None" or "AzureServices". Defaults to "AzureServices".
EOT
  default     = "AzureServices"
}

variable "anonymous_pull_enabled" {
  type        = bool
  description = "(Standard/Premium only) Whether to allow anonymous (unauthenticated) pull access."
  default     = false
}

variable "data_endpoint_enabled" {
  type        = bool
  description = "(Premium only) Whether to enable dedicated data endpoints for this Container Registry."
  default     = false
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = optional(list(string), null)
  })

  description = <<EOT
An identity block for Managed Identity on the Container Registry:
  - type can be "SystemAssigned", "UserAssigned", or "SystemAssigned, UserAssigned"
  - identity_ids is required only if using UserAssigned or combined
EOT

  default = null
}

variable "encryption" {
  type = object({
    key_vault_key_id   = string
    identity_client_id = string
  })

  description = <<EOT
Encryption block:
  - key_vault_key_id: The ID of the Key Vault Key
  - identity_client_id: The client ID of the user-assigned identity to use for ACR encryption
EOT

  default = null
}

/*
CACHE RULES
*/
variable "cache_rules" {
  type = list(object({
    name              = string
    source_repo       = string
    target_repo       = string
    credential_set_id = optional(string, null)
  }))
  description = <<EOT
A list of Cache Rules to create for this Container Registry.
Each object must have:
  - name (string)
  - source_repo (string)
  - target_repo (string)
  - credential_set_id (optional string)
EOT
  default = []
}
