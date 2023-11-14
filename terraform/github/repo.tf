data "databricks_current_user" "me" {
}

resource "databricks_repo" "databricks_champion_repo" {
    url    = var.github_url
}

resource "github_actions_variable" "databricks_unit_test_job_id" {
  repository       = var.github_repo_name
  variable_name    = "UNIT_TEST_JOB_ID"
  value            = databricks_job.unit_test.id

  depends_on = [
    databricks_job.unit_test
  ]
}

resource "github_actions_variable" "databricks_integration_test_job_id" {
  repository       = var.github_repo_name
  variable_name    = "INTEGRATION_TEST_JOB_ID"
  value            = databricks_job.integration_test.id
  depends_on = [
    databricks_job.integration_test
  ]
}