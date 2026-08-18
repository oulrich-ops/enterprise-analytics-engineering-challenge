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

