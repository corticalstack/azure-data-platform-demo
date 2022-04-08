variable "name" {
  description = "(Required) Specifies the name of the storage container"
  type        = string
}

variable "storage_account_name" {
  description = "(Required) Specifies the name of the storage account"
  type        = string
}

variable "container_access_type" {
  description = "(Required) Specifies the storage container access type"
  type        = string
}

variable "storage_container_depends_on" {
  # the value doesn't matter; we're just using this variable
  # to propagate dependencies.
  type    = any
  default = []
}