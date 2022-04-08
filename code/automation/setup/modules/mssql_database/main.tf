
resource "azurerm_mssql_database" "adventureworks" {
  name                        = var.name
  server_id                   = var.server_id
  collation                   = "SQL_Latin1_General_CP1_CI_AS"
  sample_name                 = "AdventureWorksLT"
  auto_pause_delay_in_minutes = 60
  max_size_gb                 = 5
  min_capacity                = 0.5
  read_replica_count          = 0
  read_scale                  = false
  sku_name                    = "GP_S_Gen5_1"
  zone_redundant              = false
}