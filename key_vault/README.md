# KV Terraform Module

## Usage:

```hcl
module "kv" {
  source = "git::https://github.com/Kagamashi/terraform-modules.git/key_vault?ref=v1.0.0"

  name                = "myUniqueKeyVaultName"
  location            = "West Europe"
  resource_group_name = "rg-example"
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"

  enabled_for_deployment          = false
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = false
  enable_rbac_authorization       = false
  soft_delete_retention_days      = 7
  purge_protection_enabled        = false
  public_network_access_enabled   = true

  access_policies = [
    {
      tenant_id = data.azurerm_client_config.current.tenant_id
      object_id = data.azurerm_client_config.current.object_id

      key_permissions         = ["Get", "List"]
      secret_permissions      = ["Get"]
      storage_permissions     = []
      certificate_permissions = []
    },
    # Additional policies can go here
  ]

  network_acls = {
    bypass          = "AzureServices"
    default_action  = "Deny"
    ip_rules        = ["203.0.113.42/32"]
    virtual_network_subnet_ids = []
  }

  tags = {
    environment = "dev"
    owner       = "team-xyz"
  }
}
```

---

## Notes

### Unique Name
- The name of the Key Vault **must be globally unique**.
- Once created, if you destroy it while using soft-delete or purge protection, you must **purge** it before reusing the same name.

---

### Purge Protection
- Once `purge_protection_enabled` is set to `true`, it **cannot be reverted to false**.
- Attempting to do so will fail because of Azure policy.
- Deleting a Key Vault with purge protection enabled will schedule the vault for deletion, which can take up to 90 days.

---

### Network ACLs
- If `default_action = "Deny"`, ensure you explicitly allow IP addresses or subnets; otherwise, you might lose access to the vault.

---

### Access Policies vs. RBAC
- If `enable_rbac_authorization = true`, you often manage **data-plane permissions** through Azure RBAC roles.
- If `enable_rbac_authorization = false`, you manage data-plane permissions with **access_policy** blocks or with `azurerm_key_vault_access_policy` resources.

---

### State & Sensitive Data
- Some vault secrets or references may appear in the Terraform state file if used as outputs.
- **Generally, keep secrets in the vault**, and do **not** output them directly in Terraform.
