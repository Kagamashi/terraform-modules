variable "name" {
  type        = string
  description = "Specifies the name of the Key Vault. Must be globally unique."
}

variable "location" {
  type        = string
  description = "Specifies the Azure region where the Key Vault will be created."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group in which to create the Key Vault."
}

variable "tenant_id" {
  type        = string
  description = "The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault."
}

variable "sku_name" {
  type        = string
  description = "The SKU used for the Key Vault. Possible values: 'standard', 'premium'."
  default     = "standard"
}

variable "enabled_for_deployment" {
  type        = bool
  description = "Whether Azure VMs are permitted to retrieve certificates from the vault."
  default     = false
}

variable "enabled_for_disk_encryption" {
  type        = bool
  description = "Whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys."
  default     = false
}

variable "enabled_for_template_deployment" {
  type        = bool
  description = "Whether Azure Resource Manager is permitted to retrieve secrets from the key vault."
  default     = false
}

variable "enable_rbac_authorization" {
  type        = bool
  description = <<EOT
Boolean flag to specify whether Azure Key Vault uses Role Based Access Control 
(RBAC) for authorization of data actions. 
EOT
  default     = false
}

variable "access_policies" {
  type = list(object({
    tenant_id = string
    object_id = string
    # optionally
    application_id          = optional(string, null)
    certificate_permissions = optional(list(string), [])
    key_permissions         = optional(list(string), [])
    secret_permissions      = optional(list(string), [])
    storage_permissions     = optional(list(string), [])
  }))
  description = <<EOT
A list of access_policy definitions. Each element is an object with:
  - tenant_id (required)
  - object_id (required)
  - application_id (optional)
  - certificate_permissions (list of strings, optional)
  - key_permissions (list of strings, optional)
  - secret_permissions (list of strings, optional)
  - storage_permissions (list of strings, optional)
EOT
  default     = []
}

variable "soft_delete_retention_days" {
  type        = number
  description = "Number of days to retain soft-deleted vault items (7-90)."
  default     = 7
}

variable "purge_protection_enabled" {
  type        = bool
  description = "Whether Purge Protection is enabled. Once set to true, it cannot be reverted to false."
  default     = false
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Whether public network access is allowed for this Key Vault."
  default     = true
}

variable "network_acls" {
  type = object({
    bypass                     = optional(string, null) # e.g. "AzureServices" or "None"
    default_action             = optional(string, null) # e.g. "Allow" or "Deny"
    ip_rules                   = optional(list(string), [])
    virtual_network_subnet_ids = optional(list(string), [])
  })
  description = <<EOT
An object specifying network ACLs. Example:
  {
    bypass          = "AzureServices"
    default_action  = "Deny"
    ip_rules        = ["192.168.0.0/24", "203.0.113.10/32"]
    virtual_network_subnet_ids = ["<subnetId1>", "<subnetId2>"]
  }
Set to null or omit fields if not needed.
EOT
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the Key Vault."
  default     = {}
}
