variable "name" {
  description = "(Required) Specifies the name of the sql pool"
  type        = string
}

variable synapse_workspace_id {
  description = "(Required) Specifies the resource id of the synapse workspace"
  type        = string
}

variable "sql_pool_sku" {
  description = "(Required) Specifies the sku for the SQL pool"
  type        = string
}
