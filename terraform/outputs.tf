output "raw_data_bucket_name" {
  value = module.storage.raw_data_bucket_name
}

output "bigquery_dataset_ids" {
  value = module.storage.dataset_ids
}

output "dbt_runner_email" {
  value = module.iam.dbt_runner_email
}

output "metabase_runner_email" {
  value = module.iam.metabase_runner_email
}

output "metabase_db_connection_name" {
  value = module.metabase_db.connection_name
}

output "metabase_db_public_ip" {
  value = module.metabase_db.public_ip_address
}
