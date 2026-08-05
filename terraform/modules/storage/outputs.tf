output "raw_data_bucket_name" {
  value = google_storage_bucket.raw_data.name
}

output "dataset_ids" {
  value = {
    raw     = google_bigquery_dataset.raw.dataset_id
    staging = google_bigquery_dataset.staging.dataset_id
    marts   = google_bigquery_dataset.marts.dataset_id
    sandbox = google_bigquery_dataset.sandbox.dataset_id
    ci_pr   = google_bigquery_dataset.ci_pr.dataset_id
  }
}
