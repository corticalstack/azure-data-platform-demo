output "name" {
  value = azurerm_key_vault.kv.name
  description = "Specifies the name of the key vault."
}

output "id" {
  value = azurerm_key_vault.kv.id
  description = "Specifies the resource id of the key vault."
}