variable "name" {
  type        = string
  description = "Specifies the name of the Storage Account. Must be globally unique and only lowercase alphanumeric."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group in which to create the Storage Account."
}

variable "location" {
  type        = string
  description = "Specifies the Azure region where the Storage Account will be created."
}

variable "account_kind" {
  type        = string
  description = <<EOT
Defines the Kind of account. Valid options:
  - BlobStorage
  - BlockBlobStorage
  - FileStorage
  - Storage
  - StorageV2
Defaults to "StorageV2".
EOT
  default     = "StorageV2"
}

variable "account_tier" {
  type        = string
  description = <<EOT
Defines the Tier to use for this storage account.
Valid options: "Standard", "Premium".
EOT
  default     = "Standard"
}

variable "account_replication_type" {
  type        = string
  description = <<EOT
Defines the type of replication to use. Valid options:
  - LRS
  - GRS
  - RAGRS
  - ZRS
  - GZRS
  - RAGZRS
EOT
  default     = "LRS"
}

variable "cross_tenant_replication_enabled" {
  type        = bool
  description = "Whether cross-tenant replication is enabled. Defaults to false."
  default     = false
}

variable "access_tier" {
  type        = string
  description = <<EOT
Defines the access tier for BlobStorage, FileStorage, or StorageV2 accounts.
Valid options: "Hot", "Cool", "Cold", "Premium".
Defaults to null (no tier set).
EOT
  default     = null
}

variable "https_traffic_only_enabled" {
  type        = bool
  description = "Boolean flag which forces HTTPS if enabled. Defaults to true."
  default     = true
}

variable "min_tls_version" {
  type        = string
  description = "The minimum supported TLS version for the storage account. Possible values: TLS1_0, TLS1_1, TLS1_2."
  default     = "TLS1_2"
}

variable "allow_nested_items_to_be_public" {
  type        = bool
  description = "Allow or disallow nested items within this account to opt into being public. Defaults to true."
  default     = true
}

variable "shared_access_key_enabled" {
  type        = bool
  description = <<EOT
Indicates whether the storage account permits requests to be authorized with the
account access key. Defaults to true.
EOT
  default     = true
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Whether the public network access is enabled for this account. Defaults to true."
  default     = true
}

variable "is_hns_enabled" {
  type        = bool
  description = <<EOT
Is Hierarchical Namespace enabled (for Data Lake Gen2)?
Changing this forces a new resource to be created.
EOT
  default     = false
}

variable "sftp_enabled" {
  type        = bool
  description = <<EOT
Enable SFTP for the storage account. Requires is_hns_enabled = true.
Defaults to false.
EOT
  default     = false
}

variable "nfsv3_enabled" {
  type        = bool
  description = <<EOT
Enable NFSv3 protocol.
Requires is_hns_enabled = true and account_replication_type must be LRS or RAGRS.
Defaults to false.
EOT
  default     = false
}

variable "network_rules" {
  type = object({
    default_action             = optional(string, null) # "Allow" or "Deny"
    bypass                     = optional(string, null) # e.g., "AzureServices", "Logging,Metrics", "None"
    ip_rules                   = optional(list(string), [])
    virtual_network_subnet_ids = optional(list(string), [])
  })
  description = <<EOT
Optional network_rules object. Example:
{
  default_action  = "Deny"
  bypass          = "AzureServices"
  ip_rules        = ["100.0.0.1"]
  virtual_network_subnet_ids = ["<subnet_id>"]
}
EOT
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the Storage Account."
  default     = {}
}
