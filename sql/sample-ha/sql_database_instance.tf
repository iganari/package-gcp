resource "random_string" "db_name_suffix" {
  length  = 4
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
    tier              = "${lookup(var.sql, "in_tier")}"
    availability_type = "${lookup(var.sql, "in_ha")}"
  }
}