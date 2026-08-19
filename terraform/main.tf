module "storage" {
  source = "./modules/storage"

  project_id = var.project_id
  region     = var.region
}

module "bigquery" {
  source = "./modules/bigquery"

  region = var.region
}

module "iam" {
  source = "./modules/iam"

  project_id = var.project_id
}

module "cloud_sql" {
  source = "./modules/cloud_sql"

  region               = var.region
  metabase_db_password = var.metabase_db_password
}

module "cloud_run" {
  source = "./modules/cloud_run"

  region = var.region
  # The service currently runs under the project's default compute service
  # account (it was originally deployed via `gcloud run deploy` without
  # --service-account). module.iam.metabase_runner_email exists and is
  # granted BigQuery roles, but isn't actually wired up here yet.
  service_account_email = "780659895934-compute@developer.gserviceaccount.com"
  db_host               = module.cloud_sql.public_ip_address
  db_password           = var.metabase_db_password
}
