# ACR Terraform Module

## Usage:
```hcl
module "acr" {
  source = "git::https://github.com/Kagamashi/terraform-modules.git/acr?ref=v1.0.0"

  name                = "myUniqueACRName"
  resource_group_name = "rg-example"
  location            = "West Europe"
  sku                 = "Basic"

  # Container Registry configuration
  admin_enabled = true
  tags = {
    environment = "test"
  }

  # Example of adding a Cache Rule
  cache_rules = [
    {
      name              = "exampleCacheRule"
      source_repo       = "docker.io/library/hello-world"
      target_repo       = "helloworld-cache"
      credential_set_id = null # or an ARM resource ID, if needed
    },
    # Add more cache_rules objects if desired
  ]

  # (Optional) Other advanced config like georeplications, network_rule_set, identity, encryption, etc.
  # ...
}
```

---

## Notes:

### Premium SKU Requirements

- Many advanced features (geo-replication, network rule sets, quarantine, trust policy, zone redundancy, export policy) require `sku = "Premium"`.
- If you configure these features for a non-Premium SKU, the Terraform plan may fail or ignore them.

---

### Georeplications

- **Do not** include the same location as the primary ACR.
- If multiple replicas are specified, ensure their locations are **alphabetically** sorted to avoid Terraform plan issues.

---

### Network Restrictions

- If `default_action = "Deny"` in the `network_rule_set`, make sure you explicitly allow IP ranges or subnets.
- Azure automatically adds certain network rules for Azure services; removing them may require you to specify a `network_rule_set` block with `default_action = "Deny"` to override defaults.

---

### Encryption

- If using customer-managed keys, you must supply both `key_vault_key_id` (the key identifier in Key Vault) and `identity_client_id` (the client ID of the user-assigned identity that will perform encryption).
- The same user-assigned identity must be referenced in `identity.identity_ids`.
- Ensure that user-assigned identity has proper access in Key Vault (typically `get`, `unwrapKey`, etc.).

---

### Export Policy

- If you want to disable the export policy (`export_policy_enabled = false`), you **must also** set `public_network_access_enabled = false` per Azure requirements.

---

### Anonymous Pull

- Only valid for Standard or Premium SKU.
- Will be ignored or cause errors if used with Basic.

---

### ACR Admin Credentials

- If `admin_enabled = true`, Terraform exports `admin_username` and `admin_password`.
- Use them carefully as they will appear in the Terraform state file in plain text.

---

### Role Assignments

- Attach ACR to other Azure services (e.g., AKS, App Service) via separate `azurerm_role_assignment` resources.
- For AKS, you’d typically give the cluster the built-in `AcrPull` role on the ACR scope.
