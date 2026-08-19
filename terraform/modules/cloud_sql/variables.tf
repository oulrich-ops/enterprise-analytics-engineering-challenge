variable "region" {
  description = "GCP region for the Cloud SQL instance"
  type        = string
}

variable "metabase_db_password" {
  description = "Password for Metabase's Postgres user"
  type        = string
  sensitive   = true
}
