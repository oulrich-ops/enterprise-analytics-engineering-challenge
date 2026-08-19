output "raw_data_bucket_name" {
  value = module.storage.raw_data_bucket_name
}

output "bigquery_dataset_ids" {
  value = module.bigquery.dataset_ids
}

output "dbt_runner_email" {
  value = module.iam.dbt_runner_email
}

output "metabase_runner_email" {
  value = module.iam.metabase_runner_email
}

output "metabase_db_connection_name" {
  value = module.cloud_sql.connection_name
}

output "metabase_db_public_ip" {
  value = module.cloud_sql.public_ip_address
}

output "metabase_url" {
  value = module.cloud_run.service_url
}
