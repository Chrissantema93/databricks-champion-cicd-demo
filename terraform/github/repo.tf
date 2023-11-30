data "databricks_current_user" "me" {
}

resource "databricks_repo" "databricks_champion_repo_dev" {
    url    = var.github_url
    branch = "development"
    path       = "${data.databricks_current_user.me.repos}/databricks-champions-repo-dev"
    lifecycle {
    ignore_changes = [
      branch,
    ]
  }
}

resource "databricks_repo" "databricks_champion_repo_qa" {
    url    = var.github_url
    branch = "main"
    path       = "${data.databricks_current_user.me.repos}/databricks-champions-repo-qa"
    lifecycle {
    ignore_changes = [
      branch,
    ]
  }
}

resource "databricks_repo" "databricks_champion_repo_prod" {
    url    = var.github_url
    branch = "main"
    path       = "${data.databricks_current_user.me.repos}/databricks-champions-repo-prod"
    lifecycle {
    ignore_changes = [
      branch,
    ]
  }
}


resource "github_actions_variable" "databricks_dev_repo_path" {
  repository       = var.github_repo_name
  variable_name    = "DATABRICKS_DEV_REPO_NAME"
  value            = databricks_repo.databricks_champion_repo_dev.path
}
resource "github_actions_variable" "databricks_qa_repo_path" {
  repository       = var.github_repo_name
  variable_name    = "DATABRICKS_QA_REPO_NAME"
  value            = databricks_repo.databricks_champion_repo_qa.path
}
resource "github_actions_variable" "databricks_prod_repo_path" {
  repository       = var.github_repo_name
  variable_name    = "DATABRICKS_PROD_REPO_NAME"
  value            = databricks_repo.databricks_champion_repo_prod.path
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

resource "github_actions_variable" "databricks_existing_cluster_id" {
  repository       = var.github_repo_name
  variable_name    = "DATABRICKS_EXISTING_CLUSTER_ID"
  value            = databricks_cluster.dlt_files_in_repos_testing.id
  depends_on = [
    databricks_cluster.dlt_files_in_repos_testing
  ]
}