variable "sql_ha" {
  type = "map"
  default = {
    "in_name"    = "sample-ha"
    "in_version" = "MYSQL_5_7"
    "in_region"  = "us-central1"
    "in_tier"    = "db-f1-micro"
    "in_ha"      = "REGIONAL"
  }
}

variable "sql_replica" {
  type = "map"
  default = {
    "in_name"    = "sample-replica"
    "in_version" = "MYSQL_5_7"
    "in_region"  = "us-central1"
    "in_tier"    = "db-f1-micro"
    # "in_ha"      = "REGIONAL"
    "in_ha"      = "ZONAL"
  }
}