
resource "azurerm_mssql_server" "server" {
  name                         = var.name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = "sqladminuser"
  administrator_login_password = "BeanieBoblets1234"
}

resource "azurerm_sql_firewall_rule" "example" {
  name                = "AlllowAzureServices"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mssql_server.server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}
