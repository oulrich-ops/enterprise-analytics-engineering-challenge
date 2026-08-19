module "storage" {
  source = "../../modules/storage"

  project_id = var.project_id
  region     = var.region
}

module "bigquery" {
  source = "../../modules/bigquery"

  region = var.region
}

module "iam" {
  source = "../../modules/iam"

  project_id = var.project_id
}

module "cloud_sql" {
  source = "../../modules/cloud_sql"

  region               = var.region
  metabase_db_password = var.metabase_db_password
}

module "cloud_run" {
  source = "../../modules/cloud_run"

  region                = var.region
  service_account_email = module.iam.metabase_runner_email
  db_host               = module.cloud_sql.public_ip_address
  db_password           = var.metabase_db_password
}
