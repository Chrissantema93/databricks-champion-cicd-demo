
terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "1.14.0"
    }
  }
}


provider "databricks" {
  host  = var.databricks_host != "" ? var.databricks_host : null
  token = var.databricks_pat != "" ? var.databricks_pat : null
}