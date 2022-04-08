resource "azurerm_synapse_spark_pool" "sparkpool" {
  name                 = var.name
  synapse_workspace_id = var.synapse_workspace_id
  spark_version        = var.spark_version
  node_size_family     = "MemoryOptimized"
  node_size            = "Small"
  cache_size           = 100

  auto_scale {
    max_node_count     = 3
    min_node_count     = 3
  }

  auto_pause {
    delay_in_minutes   = 10
  }
}