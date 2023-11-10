resource "databricks_job" "test" {
  name                = "DLT CICD"
  max_concurrent_runs = 1

  # job schedule
  schedule {
    quartz_cron_expression = "0 0 0 ? 1/1 * *" # cron schedule of job
    timezone_id            = "UTC"
  }

    task {
        task_key = "unit_tests"
    notebook_task {
      notebook_path = "${databricks_repo.databricks_champion_repo.path}/tests/unit-notebooks/test_column_helpers.py"
    }
    existing_cluster_id = databricks_cluster.dlt_files_in_repos_testing.id
    }


  # Create blocks for Tasks here #
  task {
    task_key = "test" # this task depends on nothing
    pipeline_task {
      pipeline_id = databricks_pipeline.databricks_champion_pipeline.id
    }
  }
  task {
    task_key = "test2"
    depends_on {
      task_key = "test"
    }
    pipeline_task {
      pipeline_id = databricks_pipeline.databricks_champion_pipeline_test.id
    }
  }
}
