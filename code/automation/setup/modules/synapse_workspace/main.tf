resource "azurerm_storage_data_lake_gen2_filesystem" "synapsecontainer" {
  name               = var.storage_container_name
  storage_account_id = var.storage_account_id
}

resource "azurerm_synapse_workspace" "synapseworkspace" {
  name                                 = var.name
  resource_group_name                  = var.resource_group_name
  location                             = var.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.synapsecontainer.id
  sql_administrator_login              = "sqladminuser"
  sql_administrator_login_password     = "BeanieBoblets1234"
  managed_virtual_network_enabled      = true  
  public_network_access_enabled        = true 
  data_exfiltration_protection_enabled = true 
}

# The Azure feature Allow access to Azure services can be enabled by setting start_ip_address and end_ip_address to 0.0.0.0.
resource "azurerm_synapse_firewall_rule" "synapse_firewall_rule" {
  depends_on           = [azurerm_synapse_workspace.synapseworkspace]
  name                 = "AllowAll"
  synapse_workspace_id = azurerm_synapse_workspace.synapseworkspace.id
  start_ip_address     = "0.0.0.0"
  end_ip_address       = "255.255.255.255"
}