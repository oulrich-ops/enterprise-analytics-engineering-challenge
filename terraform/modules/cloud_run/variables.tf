variable "region" {
  description = "GCP region for the Cloud Run service"
  type        = string
}

variable "service_account_email" {
  description = "Email of the service account Metabase runs as"
  type        = string
}

variable "metabase_image" {
  description = "Metabase container image"
  type        = string
  default     = "metabase/metabase:latest"
}

variable "db_host" {
  description = "Metabase Postgres host (public IP of the Cloud SQL instance)"
  type        = string
}

variable "db_name" {
  description = "Metabase Postgres database name"
  type        = string
  default     = "metabase"
}

variable "db_user" {
  description = "Metabase Postgres user"
  type        = string
  default     = "metabase"
}

variable "db_password" {
  description = "Metabase Postgres password"
  type        = string
  sensitive   = true
}

variable "allow_unauthenticated" {
  description = "Whether to allow public unauthenticated access to Metabase"
  type        = bool
  default     = true
}
