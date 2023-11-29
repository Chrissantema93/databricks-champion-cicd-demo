resource "databricks_job" "unit_test" {
  name                = "unit_test"
  max_concurrent_runs = 1

  git_source {
    url      = var.github_url
    branch   = "development"
    provider = "github"
  }

  task {
    task_key = "unit_tests"
    notebook_task {
      notebook_path = "tests/unit-notebooks/test_column_helpers.py"
    }
    new_cluster {
      spark_version = data.databricks_spark_version.latest_lts.id
      node_type_id  = "Standard_DS3_v2"
      num_workers   = 1
    }
  }
}

resource "databricks_job" "integration_test" {
  name                = "integration_test"
  max_concurrent_runs = 1
  # job schedule

  git_source {
    url      = var.github_url
    branch   = "main"
    provider = "github"
  }


  task {
    task_key = "pipeline"
    pipeline_task {
      pipeline_id = databricks_pipeline.databricks_champion_pipeline.id
    }
  }
  task {
    task_key = "pipeline_test"
    depends_on {
      task_key = "pipeline"
    }
    pipeline_task {
      pipeline_id = databricks_pipeline.databricks_champion_pipeline_test.id
    }
  }

}


