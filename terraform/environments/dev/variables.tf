variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "europe-west1"
}

variable "metabase_db_password" {
  description = "Password for Metabase's Postgres user"
  type        = string
  sensitive   = true
}
