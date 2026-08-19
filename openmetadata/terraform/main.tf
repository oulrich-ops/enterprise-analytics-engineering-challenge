terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
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

resource "google_project_iam_member" "openmetadata_bigquery_job" {
  project = var.project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.openmetadata_runner.email}"
}

resource "google_project_iam_member" "openmetadata_bigquery_resource_viewer" {
  project = var.project_id
  role    = "roles/bigquery.resourceViewer"
  member  = "serviceAccount:${google_service_account.openmetadata_runner.email}"
}

resource "google_project_iam_member" "openmetadata_datacatalog" {
  project = var.project_id
  role    = "roles/datacatalog.viewer"
  member  = "serviceAccount:${google_service_account.openmetadata_runner.email}"
}

resource "google_project_iam_member" "openmetadata_storage_viewer" {
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.openmetadata_runner.email}"
}

# The raw-data bucket is managed in terraform/environments/prod (a separate
# Terraform root/state), so it's looked up here rather than referenced
# directly as a resource.
data "google_storage_bucket" "raw_data" {
  name = "${var.project_id}-raw-data"
}

resource "google_storage_bucket_iam_member" "openmetadata_bucket_admin" {
  bucket = data.google_storage_bucket.raw_data.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.openmetadata_runner.email}"
}

