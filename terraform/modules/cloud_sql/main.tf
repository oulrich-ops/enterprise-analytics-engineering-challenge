resource "google_project_service" "sqladmin" {
  service            = "sqladmin.googleapis.com"
  disable_on_destroy = false
}

resource "google_sql_database_instance" "metabase_db" {
  name             = "metabase-db"
  database_version = "POSTGRES_15"
  region           = var.region

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled = true
      authorized_networks {
        name  = "allow-all-temp"
        value = "0.0.0.0/0"
      }
    }
  }

  deletion_protection = false

  depends_on = [google_project_service.sqladmin]
}

resource "google_sql_database" "metabase" {
  name     = "metabase"
  instance = google_sql_database_instance.metabase_db.name
}

resource "google_sql_user" "metabase_user" {
  name     = "metabase"
  instance = google_sql_database_instance.metabase_db.name
  password = var.metabase_db_password
}
