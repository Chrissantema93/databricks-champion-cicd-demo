resource "databricks_job" "test" {
  name                = "DLT CICD"
  max_concurrent_runs = 1
  # job schedule
  schedule {
    quartz_cron_expression = "0 0 0 ? 1/1 * *" # cron schedule of job
    timezone_id            = "UTC"
  }

  git_source {
    url =  var.github_url
    branch =  "development"
  }

    task {
        task_key = "unit_tests"
    notebook_task {
      notebook_path = "tests/unit-notebooks/test_column_helpers.py"
    }
    existing_cluster_id = databricks_cluster.dlt_files_in_repos_testing.id
    }


  # Create blocks for Tasks here #
  task {
    task_key = "pipeline" 
    depends_on {
      task_key = "unit_tests"
    }
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
