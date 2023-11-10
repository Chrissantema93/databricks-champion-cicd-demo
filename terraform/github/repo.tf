data "databricks_current_user" "me" {
}

resource "databricks_repo" "databricks_champion_repo" {
    url    = var.github_url
}
