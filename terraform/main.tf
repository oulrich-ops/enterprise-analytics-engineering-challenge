resource "google_storage_bucket" "raw_data" {
  name          = "${var.project_id}-raw-data"
  location      = "us-central1"
  force_destroy = false

  uniform_bucket_level_access = true
}

resource "google_bigquery_dataset" "raw" {
  dataset_id = "raw"
  location   = "us-central1"
}

resource "google_bigquery_dataset" "staging" {
  dataset_id = "staging"
  location   = "us-central1"
}

resource "google_bigquery_dataset" "marts" {
  dataset_id = "marts"
  location   = "us-central1"
}

resource "google_service_account" "dbt_runner" {
  account_id   = "dbt-runner"
  display_name = "Service account used by dbt"
}