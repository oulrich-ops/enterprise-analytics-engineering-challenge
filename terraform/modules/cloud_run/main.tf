resource "google_cloud_run_v2_service" "metabase" {
  name     = "metabase"
  location = var.region

  template {
    service_account = var.service_account_email

    containers {
      image = var.metabase_image

      ports {
        container_port = 3000
      }

      env {
        name  = "MB_DB_TYPE"
        value = "postgres"
      }

      env {
        name  = "MB_DB_DBNAME"
        value = var.db_name
      }

      env {
        name  = "MB_DB_PORT"
        value = "5432"
      }

      env {
        name  = "MB_DB_USER"
        value = var.db_user
      }

      env {
        name  = "MB_DB_PASS"
        value = var.db_password
      }

      env {
        name  = "MB_DB_HOST"
        value = var.db_host
      }

      resources {
        cpu_idle          = true
        startup_cpu_boost = true

        limits = {
          cpu    = "2"
          memory = "2Gi"
        }
      }
    }
  }

  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }
}

resource "google_cloud_run_v2_service_iam_member" "public_access" {
  count = var.allow_unauthenticated ? 1 : 0

  location = google_cloud_run_v2_service.metabase.location
  name     = google_cloud_run_v2_service.metabase.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
