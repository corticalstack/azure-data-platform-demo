data "azurerm_client_config" "current" {
}

locals {
  storage_account_lake = {
    name = "csresearchdpolaplakest"
    replication_type = "LRS"
    account_kind     = "StorageV2"
    account_tier     = "Standard"
    min_tls_version  = "TLS1_2"
    is_hns_enabled   = true
  }

   storage_account_ml = {
    name = "csresearchdpssmlst"
    replication_type = "LRS"
    account_kind     = "Storage"
    account_tier     = "Standard"
    min_tls_version  = "TLS1_2"
    is_hns_enabled   = false
  }
}

resource "azurerm_resource_group" "dp" {
  name     = var.resource_group_name_dp
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "dp_ss" {
  name     = var.resource_group_name_dp_ss
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "erpcore" {
  name     = var.resource_group_name_erpcore
  location = var.location
  tags     = var.tags
}

module "storage_account_lake" {
  source                      = "./modules/storage_account"
  name                        = "${local.storage_account_lake.name}"
  location                    = var.location
  resource_group_name         = azurerm_resource_group.dp.name
  account_kind                = "${local.storage_account_lake.account_kind}"
  account_tier                = "${local.storage_account_lake.account_tier}"
  replication_type            = "${local.storage_account_lake.replication_type}"
  min_tls_version             = "${local.storage_account_lake.min_tls_version}"
  is_hns_enabled              = "${local.storage_account_lake.is_hns_enabled}"
}

module "storage_account_ml" {
  source                      = "./modules/storage_account"
  name                        = "${local.storage_account_ml.name}"
  location                    = var.location
  resource_group_name         = azurerm_resource_group.dp_ss.name
  account_kind                = "${local.storage_account_ml.account_kind}"
  account_tier                = "${local.storage_account_ml.account_tier}"
  replication_type            = "${local.storage_account_ml.replication_type}"
  min_tls_version             = "${local.storage_account_ml.min_tls_version}"
  is_hns_enabled              = "${local.storage_account_ml.is_hns_enabled}"
}

# Allows built-in SQL pool to access storage when querying for example
resource "azurerm_role_assignment" "data-contributor-role" {
  scope                = module.storage_account_lake.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = "0c424e8e-9f6f-4940-8a0c-841c2a449a33"
}

module "storage_container" {
  source                         = "./modules/storage_container"
  for_each                       = var.storage_container
    name                         = "${each.key}"
    storage_account_name         = "${each.value.storage_account_name}"
    container_access_type        = "${each.value.container_access_type}"
    storage_container_depends_on = [module.storage_account_lake.id]
}


module "key_vault" {
  source                          = "./modules/key_vault"
  name                            = var.key_vault_name
  location                        = var.location
  resource_group_name             = azurerm_resource_group.dp_ss.name
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  sku_name                        = var.key_vault_sku_name
  enabled_for_deployment          = var.key_vault_enabled_for_deployment
  enabled_for_disk_encryption     = var.key_vault_enabled_for_disk_encryption
  enabled_for_template_deployment = var.key_vault_enabled_for_template_deployment
  enable_rbac_authorization       = var.key_vault_enable_rbac_authorization
  purge_protection_enabled        = var.key_vault_purge_protection_enabled
  soft_delete_retention_days      = var.key_vault_soft_delete_retention_days
}

module "mssql_server" {
  source                          = "./modules/mssql_server"
  name                            = var.mssql_server_name
  location                        = var.location
  resource_group_name             = azurerm_resource_group.erpcore.name
}

module "mssql_database" {
  source                          = "./modules/mssql_database"
  name                            = var.mssql_database_name
  server_id                       = module.mssql_server.id
}

module "synapse_workspace" {
  source                    = "./modules/synapse_workspace"
  name                      = var.synapse_workspace_name
  storage_container_name    = "synapsecontainer"
  storage_account_id        = module.storage_account_lake.id
  resource_group_name       = azurerm_resource_group.dp.name
  location                  = var.location
}

module "synapse_sql_pool" {
  source                    = "./modules/synapse_sql_pool"
  name                      = var.synapse_sql_pool_01_name
  synapse_workspace_id      = module.synapse_workspace.id
  sql_pool_sku              = var.synapse_sql_pool_01_sku
}

module "synapse_spark_pool" {
  source                    = "./modules/synapse_spark_pool"
  name                      = var.synapse_spark_pool_01_name
  synapse_workspace_id      = module.synapse_workspace.id
  spark_version             = var.spark_version
}

