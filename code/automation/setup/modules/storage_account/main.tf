locals {
  module_tags = {
    "TerraformModule" = basename(abspath(path.module)),
    "CreatedWith" = "Terraform"
  }
  tags = merge(var.tags, local.module_tags)
}

resource "azurerm_storage_account" "storage_account" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_kind             = var.account_kind
  account_tier             = var.account_tier
  account_replication_type = var.replication_type
  is_hns_enabled           = var.is_hns_enabled
  tags                     = local.tags

  identity {
    type = "SystemAssigned"
  }
}
