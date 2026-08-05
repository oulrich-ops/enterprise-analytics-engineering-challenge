module "storage" {
  source = "./modules/storage"

  project_id = var.project_id
  region     = var.region
}

module "iam" {
  source = "./modules/iam"

  project_id = var.project_id
}

module "metabase_db" {
  source = "./modules/metabase_db"

  region               = var.region
  metabase_db_password = var.metabase_db_password
}
