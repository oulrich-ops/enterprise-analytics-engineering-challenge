resource "google_storage_bucket" "raw_data" {
  name          = "${var.project_id}-raw-data"
  location      = var.region
  force_destroy = false

  uniform_bucket_level_access = true
}

resource "google_bigquery_dataset" "raw" {
  dataset_id = "raw"
  location   = var.region
}

resource "google_bigquery_dataset" "staging" {
  dataset_id = "staging"
  location   = var.region
}

resource "google_bigquery_dataset" "marts" {
  dataset_id = "marts"
  location   = var.region
}

resource "google_bigquery_dataset" "sandbox" {
  dataset_id = "sandbox"
  location   = var.region
}

resource "google_bigquery_dataset" "ci_pr" {
  dataset_id = "ci_pr"
  location   = var.region
}
