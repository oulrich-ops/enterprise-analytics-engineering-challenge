output "instance_name" {
  value = google_sql_database_instance.metabase_db.name
}

output "connection_name" {
  value = google_sql_database_instance.metabase_db.connection_name
}

output "public_ip_address" {
  value = google_sql_database_instance.metabase_db.public_ip_address
}
