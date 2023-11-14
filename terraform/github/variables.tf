variable "github_pat" {
  description = "The GitHub PAT"
  type        = string
  sensitive   = true
}

variable "github_url" {
  description = "The GitHub repo URL"
  type        = string
  sensitive   = true
}

variable "github_repo_name" {
  description = "The GitHub repo name"
  type        = string
  sensitive   = true
}

variable "databricks_pat" {
  description = "The Databricks PAT"
  type        = string
  sensitive   = true
}

variable "databricks_host" {
  description = "The Databricks host"
  type        = string
  sensitive   = true
}

