locals {
  module_tags = {
    "TerraformModule" = basename(abspath(path.module)),
    "CreatedWith" = "Terraform"
  }
  tags = merge(var.tags, local.module_tags)
}

data "azuread_user" "ref-admin-user" {
  user_principal_name = "admin@jpcorticalstackai.onmicrosoft.com"
}

resource "azurerm_key_vault" "kv" {
  name                            = var.name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  tenant_id                       = var.tenant_id
  sku_name                        = var.sku_name
  tags                            = local.tags
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  enable_rbac_authorization       = var.enable_rbac_authorization
  purge_protection_enabled        = var.purge_protection_enabled
  soft_delete_retention_days      = var.soft_delete_retention_days
  
  timeouts {
    delete = "60m"
  }

  access_policy {
    tenant_id                       = var.tenant_id
    object_id                       = "${data.azuread_user.ref-admin-user.object_id}"
    key_permissions = [
      "Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore"
    ]

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"
    ]

    certificate_permissions = [
      "Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"
    ]
  }
}


resource "azurerm_key_vault_secret" "kv-secret-sqladminuser-pwd" {
  name         = "AZ-DP-SQLADMINUSER-PWD"
  value        = "${var.AZ_DP_SQLADMINUSER_PWD}"
  key_vault_id = azurerm_key_vault.kv.id
  depends_on = [azurerm_key_vault.kv]
}
