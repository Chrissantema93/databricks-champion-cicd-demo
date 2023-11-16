data "databricks_node_type" "standard" {
  category = "General Purpose"
}

data "databricks_spark_version" "latest_lts" {
  long_term_support = true
}


resource "databricks_cluster" "dlt_files_in_repos_testing" {
  cluster_name            = "DLT Files in Repos notebooks testing (${data.databricks_current_user.me.alphanumeric})"
  spark_version           = data.databricks_spark_version.latest_lts.id
  node_type_id            = "Standard_DS3_v2"
  autotermination_minutes = 20
  spark_conf = {
    # Single-node
    "spark.databricks.cluster.profile" : "singleNode"
    "spark.master" : "local[*]"
  }

  custom_tags = {
    "ResourceClass" = "SingleNode"
  }

  library {
    pypi {
      package = "nutter"
    }
  }
  library {
    pypi {
      package = "chispa"
    }
  }

}
