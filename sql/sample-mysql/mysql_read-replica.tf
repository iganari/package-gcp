resource "random_string" "db_name_suffix_replica" {
  length  = 6
  upper   = false
  lower   = true
  number  = false
  special = false
}

# https://www.terraform.io/docs/providers/google/r/sql_database_instance.html
resource "google_sql_database_instance" "gsdi_replica" {
  name             = "${lookup(var.sql_replica, "in_name")}-${random_string.db_name_suffix_replica.id}"
  region           = "${lookup(var.sql_replica, "in_region")}"
  database_version = "${lookup(var.sql_replica, "in_version")}"

  settings {
    availability_type      = "${lookup(var.sql_replica, "in_ha")}"
    tier                   = "${lookup(var.sql_replica, "in_tier")}"
    crash_safe_replication = true

    backup_configuration {
      enabled            = true
      binary_log_enabled = true
      start_time         = "15:00"
    }
  }
}