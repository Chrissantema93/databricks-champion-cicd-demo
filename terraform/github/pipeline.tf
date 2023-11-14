resource "databricks_pipeline" "databricks_champion_pipeline" {
  name    = "databricks_champion_pipeline"
  storage = "/test/first-pipeline"


  cluster {
    node_type_id            = data.databricks_node_type.smallest.id
    num_workers = 1
  }
  library {
    notebook {
      path = "${databricks_repo.databricks_champion_repo.path}/pipelines/DLT-Pipeline"
    }
  }
  continuous = false
  development = true
}

resource "databricks_pipeline" "databricks_champion_pipeline_test" {
  name    = "databricks_champion_pipeline_test"
  storage = "/test/first-pipeline"

  cluster {
    node_type_id            = data.databricks_node_type.smallest.id
    num_workers = 1
  }

  library {
    notebook {
      path = "${databricks_repo.databricks_champion_repo.path}/tests/integration/DLT-Pipeline-Test"
    }
  }
  continuous = false
  development = true

  configuration = {
    "my_etl.data_path" = "/databricks-datasets/wikipedia-datasets/data-001/clickstream/raw-uncompressed-json/2015_2_clickstream.json"
  }
}
