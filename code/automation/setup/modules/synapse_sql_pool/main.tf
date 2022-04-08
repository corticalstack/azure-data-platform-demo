resource "azurerm_synapse_sql_pool" "sqlpool" {
  name                 = var.name
  synapse_workspace_id = var.synapse_workspace_id
  sku_name             = var.sql_pool_sku
  create_mode          = "Default"
}