


resource "random_string" "db_name_suffix" {
  length  = 4
  upper   = false
  lower   = true
  number  = false
  special = false
}




# https://www.terraform.io/docs/providers/google/r/sql_database_instance.html
resource "google_sql_database_instance" "gsdi_master" {
  name             = "${lookup(var.database, "db_name")}-${random_string.db_name_suffix.id}"
  region           = "${lookup(var.database, "db_region")}"
  database_version = "${lookup(var.database, "db_version")}"

  settings {
    tier = "db-f1-micro"
  }

  # replica_configuration = ["${var.replica_configuration}"]

}