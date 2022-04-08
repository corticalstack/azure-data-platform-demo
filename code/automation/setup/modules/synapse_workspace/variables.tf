variable "name" {
  description = "(Required) Specifies the name of the blob"
  type        = string
}

variable "storage_container_name" {
  description = "(Required) Specifies the name of the storage container"
  type        = string
}

variable storage_account_id {
  description = "(Required) Specifies the resource id of the storage account"
  type        = string
}

variable "location" {
  description = "(Required) Specifies the location of the storage account"
  type        = string
}

variable "resource_group_name" {
  description = "(Required) Specifies the resource group name of the storage account"
  type        = string
}