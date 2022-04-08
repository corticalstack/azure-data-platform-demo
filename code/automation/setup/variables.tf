variable "tags" {
  description = "(Optional) Specifies tags for all the resources"
  default     = {
    Group       = "Research",
    Project     = "Data Platform",
    Environment = "Production"
  }
}

variable "location" {
  description = "Specifies the location for the resource group and all the resources"
  default     = "westeurope"
  type        = string
}

variable "resource_group_name_dp" {
  description = "Specifies the data platform resource group name"
  default     = "cs-eur-research-dp-rg"
  type        = string
}

variable "resource_group_name_dp_ss" {
  description = "Specifies the data platform shared services resource group name"
  default     = "cs-eur-research-dp-ss-rg"
  type        = string
}

variable "resource_group_name_erpcore" {
  description = "Specifies the erpcore resource group name"
  default     = "cs-eur-research-erpcore-rg"
  type        = string
}

variable "storage_container" {
  description = "Map of container names to configuration"
  type        = map
  default     = {
    raw = {
      name = "raw",
      storage_account_name = "csresearchdpolaplakest",
      container_access_type = "private"
    },
    enriched = {
      name = "enriched",
      storage_account_name = "csresearchdpolaplakest",
      container_access_type = "private"
    },
    curated = {
      name = "curated",
      storage_account_name = "csresearchdpolaplakest",
      container_access_type = "private"
    }
  }
}


variable "synapse_workspace_name" {
  description = "Specifies the synapse workspace name"
  default     = "cs-eur-research-dp-olap-synw"
  type        = string
}

variable "synapse_sql_pool_01_name" {
  description = "Specifies the synapse sql pool 01 name"
  default     = "sqlpool01"
  type        = string
}

variable "synapse_sql_pool_01_sku" {
  description = "Specifies the synapse sql pool 01 sku"
  default     = "DW100c"
  type        = string
}

variable "synapse_spark_pool_01_name" {
  description = "Specifies the synapse spark pool 01 name"
  default     = "sparkpool01"
  type        = string
}

variable "spark_version" {
  description = "Spark version."
  type        = number
  default     = 2.4
}


variable "key_vault_name" {
  description = "Specifies the name of the key vault."
  type        = string
  default     = "cs-eur-research-dp-ss-kv"
}

variable "key_vault_sku_name" {
  description = "(Required) The Name of the SKU used for this Key Vault. Possible values are standard and premium."
  type        = string
  default     = "standard"

  validation {
    condition = contains(["standard", "premium" ], var.key_vault_sku_name)
    error_message = "The sku name of the key vault is invalid."
  }
}

variable"key_vault_enabled_for_deployment" {
  description = "(Optional) Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault. Defaults to false."
  type        = bool
  default     = false
}

variable"key_vault_enabled_for_disk_encryption" {
  description = " (Optional) Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys. Defaults to false."
  type        = bool
  default     = false
}

variable"key_vault_enabled_for_template_deployment" {
  description = "(Optional) Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault. Defaults to true."
  type        = bool
  default     = true
}

variable"key_vault_enable_rbac_authorization" {
  description = "(Optional) Boolean flag to specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions. Defaults to false."
  type        = bool
  default     = false
}

variable"key_vault_purge_protection_enabled" {
  description = "(Optional) Is Purge Protection enabled for this Key Vault? Defaults to true."
  type        = bool
  default     = true
}

variable "key_vault_soft_delete_retention_days" {
  description = "(Optional) The number of days that items should be retained for once soft-deleted. This value can be between 7 and 90 (the default) days."
  type        = number
  default     = 7
}

variable "AZ_DP_SQLADMINUSER_PWD" {
  description = "(Required) SQL Admin User Password"
  type        = string
  default     = "SQL admin user password here"
}


variable "mssql_server_name" {
  description = "Specifies the name of the MSSQL Server"
  type        = string
  default     = "cs-eur-research-erpcore-sql"
}

variable "mssql_database_name" {
  description = "Specifies the name of the MSSQL Database"
  type        = string
  default     = "sqldb-aw"
}
