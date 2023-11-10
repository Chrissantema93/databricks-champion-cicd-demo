
terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "1.14.0"
    }
  }
}

provider "databricks" {
  host  = var.databricks_host
  token = var.databricks_pat
}

