resource "google_service_account" "dbt_runner" {
  account_id   = "dbt-runner"
  display_name = "Service account used by dbt"
}

resource "google_project_iam_member" "dbt_runner_bigquery_data" {
  project = var.project_id
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${google_service_account.dbt_runner.email}"
}

resource "google_project_iam_member" "dbt_runner_bigquery_job" {
  project = var.project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.dbt_runner.email}"
}

resource "google_service_account" "metabase_runner" {
  account_id   = "metabase-runner"
  display_name = "Service account used by Metabase"
}

resource "google_project_iam_member" "metabase_bigquery_data" {
  project = var.project_id
  role    = "roles/bigquery.dataViewer"
  member  = "serviceAccount:${google_service_account.metabase_runner.email}"
}

resource "google_project_iam_member" "metabase_bigquery_job" {
  project = var.project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.metabase_runner.email}"
}

resource "google_project_iam_member" "metabase_bigquery_metadata" {
  project = var.project_id
  role    = "roles/bigquery.metadataViewer"
  member  = "serviceAccount:${google_service_account.metabase_runner.email}"
}

resource "google_service_account" "openmetadata_runner" {
  account_id   = "openmetadata-runner"
  display_name = "Service account used by OpenMetadata"
}

resource "google_project_iam_member" "openmetadata_bigquery_data" {
  project = var.project_id
  role    = "roles/bigquery.dataViewer"
  member  = "serviceAccount:${google_service_account.openmetadata_runner.email}"
}

resource "google_project_iam_member" "openmetadata_bigquery_metadata" {
  project = var.project_id
  role    = "roles/bigquery.metadataViewer"
  member  = "serviceAccount:${google_service_account.openmetadata_runner.email}"
}
