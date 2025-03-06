# Storage Account Module

## Usage:

```hcl
provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

module "storage_account" {
  source = "./modules/azure_storage_account"  # or a Git/GitHub URL

  name                = "mystorageacct123"  # Must be globally unique & all lowercase
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "GRS"

  cross_tenant_replication_enabled = false
  access_tier                      = "Hot"
  https_traffic_only_enabled       = true
  min_tls_version                  = "TLS1_2"
  allow_nested_items_to_be_public  = true
  shared_access_key_enabled        = true
  public_network_access_enabled    = true
  is_hns_enabled                   = false
  sftp_enabled                     = false
  nfsv3_enabled                    = false

  # Example of network rules
  network_rules = {
    default_action             = "Deny"
    bypass                     = "AzureServices"
    ip_rules                   = ["100.0.0.1"]
    virtual_network_subnet_ids = []
  }

  tags = {
    environment = "staging"
    owner       = "team-storage"
  }
}

output "storage_account_id" {
  description = "Storage Account ID"
  value       = module.storage_account.id
}

output "storage_account_primary_access_key" {
  description = "Primary Access Key"
  value       = module.storage_account.primary_access_key
  sensitive   = true
}
```

---

## Notes:

### Globally Unique Name
- The Storage Account name must be **globally unique**.
- If you attempt to reuse a name of a previously deleted Storage Account, ensure it’s fully **purged** in Azure beforehand.


### Replication Types
- Changing replication types (e.g., from `LRS` to `ZRS` or `GZRS`) can require the resource to be **recreated**.
- Plan carefully to avoid downtime.


### Network Rules
- If `default_action = "Deny"`, explicitly allow the IP addresses or subnets you need, otherwise you may lock out access.
- IP rules must be **valid public IPv4 ranges**. `/31`, `/32`, and private IP addresses are not allowed.


### Hierarchical Namespace
- If `is_hns_enabled = true`, the account is effectively a Data Lake Storage Gen2 account. Typically used with `account_kind="StorageV2"` and `account_replication_type` in `[LRS, RAGRS]`.
- Enabling SFTP or NFSv3 is only valid under certain conditions (see official Azure documentation).


### TLS Requirements
- Azure requires TLS 1.2 or higher starting in August 2025.
- By default, we set `min_tls_version = "TLS1_2"` for new storage accounts.


### Access Keys in State
- This module outputs `primary_access_key` and `primary_connection_string`, both marked as **sensitive**.
- They appear in the Terraform **state file** in plain text. Use them carefully or avoid outputting them if possible.
