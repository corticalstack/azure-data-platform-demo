variable "name" {
  description = "(Required) Specifies the name of the sql server"
  type        = string
}

variable "resource_group_name" {
  description = "(Required) Specifies the resource group name of the MSSQL Server"
  type        = string
}

variable "location" {
  description = "(Required) Specifies the location of the MSSQL Server"
  type        = string
}
