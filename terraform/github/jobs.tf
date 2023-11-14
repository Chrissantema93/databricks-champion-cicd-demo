resource "databricks_job" "unit_test" {
  name                = "unit_test"
  max_concurrent_runs = 1

  git_source {
    url    = var.github_url
    branch = "development"
    provider = "github"
  }

  task {
    task_key = "unit_tests"
    notebook_task {
      notebook_path = "tests/unit-notebooks/test_column_helpers.py"
    }
    existing_cluster_id = databricks_cluster.dlt_files_in_repos_testing.id
  }
}

resource "databricks_job" "integration_test" {
  name                = "integration_test"
  max_concurrent_runs = 1
  # job schedule

  git_source {
    url    = var.github_url
    branch = "main"
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


