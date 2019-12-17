resource "random_string" "db_name_suffix" {
  length  = 6
  upper   = false
  lower   = true
  number  = false
  special = false
}


# https://www.terraform.io/docs/providers/google/r/sql_database_instance.html
resource "google_sql_database_instance" "gsdi_master" {
  name             = "${lookup(var.sql, "in_name")}-${random_string.db_name_suffix.id}"
  region           = "${lookup(var.sql, "in_region")}"
  database_version = "${lookup(var.sql, "in_version")}"

  settings {
    availability_type      = "${lookup(var.sql, "in_ha")}"
    tier                   = "${lookup(var.sql, "in_tier")}"
    crash_safe_replication = true

    backup_configuration {
      binary_log_enabled = true
      enabled            = true
      start_time         = "00:00"
    }
  }

}